// Copyright Jamie Iles, 2017
//
// This file is part of s80x86.
//
// s80x86 is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// s80x86 is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with s80x86.  If not, see <http://www.gnu.org/licenses/>.

#include "config.h"
#include "bda.h"
#include "bios.h"
#include "display.h"
#include "sd.h"
#include "io.h"
#include "serial.h"
#include "keyboard.h"
#include "mouse.h"
#include "timer.h"
#include "utils.h"

#define INT11_DISKS_PRESENT (1 << 0)
#define INT11_CGA_ADAPTOR (2 << 4)
#define INT11_POINTER_PRESENT (1 << 2)

static void equipment_check(struct callregs *regs)
{
    regs->ax.x = INT11_CGA_ADAPTOR | INT11_POINTER_PRESENT;
}
VECTOR(0x11, equipment_check);

static void serial_services(struct callregs *regs)
{
    regs->flags |= CF;
}
VECTOR(0x14, serial_services);

static void system_services(struct callregs *regs)
{
    regs->flags |= CF;
    if (regs->ax.h == 0xc2)
        mouse_services(regs);
}
VECTOR(0x15, system_services);

// Printer services
static void printer_services(struct callregs *regs)
{
    regs->flags |= CF;
}
VECTOR(0x17, printer_services);

static void basic_services(struct callregs __unused *regs)
{
    panic("No basic services\n");
}
VECTOR(0x18, basic_services);

static void boostrap_loader(struct callregs __unused *regs)
{
    asm volatile("jmp $0xffff, $0x0");
}
VECTOR(0x19, boostrap_loader);

static void conventional_memory(struct callregs *regs)
{
    regs->ax.x = 640;
}
VECTOR(0x12, conventional_memory);

static void break_handler(struct callregs __unused *regs)
{
    panic("No break handler\n");
}
VECTOR(0x1b, break_handler);

static void set_vector(int vector, void *handler)
{
    writew(0, vector * 4, (unsigned short)handler);
    writew(0, vector * 4 + 2, get_cs());
}

static unsigned char vpt[] = {80, 25, 8, 4000 & 0xff, 4000 >> 8};

static void install_vectors(void)
{
    struct vector {
        unsigned short num;
        void *handler;
    };

    extern struct vector vectors_start;
    extern struct vector vectors_end;

    struct vector *v;

    for (v = &vectors_start; v < &vectors_end; ++v)
        set_vector(v->num, v->handler);

    set_vector(0x1d, vpt);
}

static void bda_init(void)
{
    int i;

    for (i = 0; i < 256; ++i)
        writeb(0x40, i, 0);
}

#define PIC_COMMAND 0x20
#define PIC_DATA 0x21

#define PIC_ICW1_INIT (1 << 4)
#define PIC_ICW1_SINGLE (1 << 1)
#define PIC_ICW1_ICW4 (1 << 0)
#define PIC_ICW4_8086 (1 << 0)

static void irq_init(void)
{
    outb(PIC_COMMAND, PIC_ICW1_INIT | PIC_ICW1_SINGLE | PIC_ICW1_ICW4);
    outb(PIC_DATA, 0x08);
    outb(PIC_DATA, PIC_ICW4_8086);
    // All IRQs initially masked.
    outb(PIC_DATA, ~0);

    irq_ack();
}

void irq_enable(int irq_num)
{
    outb(PIC_DATA, inb(PIC_DATA) & ~(1 << irq_num));
}

void irq_disable(int irq_num)
{
    outb(PIC_DATA, inb(PIC_DATA) | (1 << irq_num));
}

void irq_ack(void)
{
    outb(0x20, 0x20);
}

unsigned long jiffies(void)
{
    unsigned short low, high;
    int enable_irqs = irqs_enabled();

    cli();
    low = bda_read(timer_counter_low);
    high = bda_read(timer_counter_high);
    if (enable_irqs)
        sti();

    return ((unsigned long)high << 16) | low;
}

void root(void)
{
    install_vectors();

    irq_init();
    bda_init();
    display_init();

    putstr("s80x86 BIOS, (C) Jamie Iles, " __DATE__ " " __TIME__ "\n");
    putstr("Platform: " __PLATFORM__ "\n");
    putstr("Build: " __BUILD__ "\n");
    printk("Cache: %uKB\n", CACHE_SIZE / 1024);
    printk("Pseudo-286: %s\n", S80X86_PSEUDO_286 ? "enabled" : "disabled");
    putstr("\n");

    init_timer();

    keyboard_init();
    mouse_hw_init();

    sd_init();
    sd_boot();
}
