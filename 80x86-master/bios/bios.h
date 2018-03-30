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

#pragma once

#include "bda.h"

#define __unused __attribute__((unused))

/* Pushed by the INT handlers in the order that a PUSHA would. */
union reg {
    struct {
        unsigned char l;
        unsigned char h;
    };
    unsigned short x;
};

struct callregs {
    union reg di;
    union reg si;
    union reg bp;
    union reg sp;
    union reg bx;
    union reg dx;
    union reg cx;
    union reg ax;
    unsigned short ds;
    unsigned short flags;
};

enum FlagBitPos {
    CF_OFFS = 0,
    PF_OFFS = 2,
    AF_OFFS = 4,
    ZF_OFFS = 6,
    SF_OFFS = 7,
    TF_OFFS = 8,
    IF_OFFS = 9,
    DF_OFFS = 10,
    OF_OFFS = 11
};

enum Flag {
    CF = (1 << CF_OFFS),
    PF = (1 << PF_OFFS),
    AF = (1 << AF_OFFS),
    ZF = (1 << ZF_OFFS),
    SF = (1 << SF_OFFS),
    TF = (1 << TF_OFFS),
    IF = (1 << IF_OFFS),
    DF = (1 << DF_OFFS),
    OF = (1 << OF_OFFS),
};

#define VECTOR(vnum, handler)                                     \
    static void __attribute__((used)) handler(struct callregs *); \
    asm(".pushsection .text, \"ax\"\n"                            \
        "1:\n"                                                    \
        "cli\n"                                                   \
        "push $" #handler                                         \
        "\n"                                                      \
        "jmp irq_entry\n"                                         \
        ".pushsection .rodata.vectors\n"                          \
        ".align 4\n"                                              \
        ".word " #vnum                                            \
        "\n"                                                      \
        ".word 1b\n"                                              \
        ".popsection")

#define HWIRQ(vnum, handler)                                      \
    static void __attribute__((used)) handler(struct callregs *); \
    asm(".pushsection .text, \"ax\"\n"                            \
        "1:\n"                                                    \
        "cli\n"                                                   \
        "push $" #handler                                         \
        "\n"                                                      \
        "jmp hw_irq_entry\n"                                      \
        ".pushsection .rodata.vectors\n"                          \
        ".align 4\n"                                              \
        ".word " #vnum                                            \
        "\n"                                                      \
        ".word 1b\n"                                              \
        ".popsection")

#define bda_write(field, val)                                                \
    ({                                                                       \
        typeof(((struct bios_data_area *)0)->field) _p = (val);              \
        if (__builtin_types_compatible_p(typeof(_p), unsigned short))        \
            writew(0x40, offsetof(struct bios_data_area, field), _p);        \
        else if (__builtin_types_compatible_p(typeof(_p), unsigned char))    \
            writeb(0x40, offsetof(struct bios_data_area, field), _p);        \
        else                                                                 \
            memcpy_seg(0x40, (void *)offsetof(struct bios_data_area, field), \
                       get_cs(), &_p, sizeof(_p));                           \
    })

#define bda_read(field)                                                   \
    ({                                                                    \
        typeof(((struct bios_data_area *)0)->field) _p;                   \
        if (__builtin_types_compatible_p(typeof(_p), unsigned short))     \
            _p = readw(0x40, offsetof(struct bios_data_area, field));     \
        else if (__builtin_types_compatible_p(typeof(_p), unsigned char)) \
            _p = readb(0x40, offsetof(struct bios_data_area, field));     \
        else                                                              \
            memcpy_seg(get_cs(), &_p, 0x40,                               \
                       (void *)offsetof(struct bios_data_area, field),    \
                       sizeof(_p));                                       \
        _p;                                                               \
    })

#define offsetof __builtin_offsetof
#define noinline __attribute__((noinline))

void irq_enable(int irq_num);
void irq_disable(int irq_num);
void irq_ack(void);
void printk(const char *fmt, ...);

static inline void cli(void)
{
    asm volatile("cli");
}

static inline void sti(void)
{
    // A nop is inserted so that an sti+cli pair has chance to yield to
    // interrupts
    asm volatile(
        "sti\n"
        "nop");
}

unsigned long jiffies(void);

static inline int irqs_enabled(void)
{
    unsigned short flags;

    asm volatile(
        "pushf\n"
        "pop %0"
        : "=r"(flags)
        :
        : "memory");

    return !!(flags & (1 << 9));
}

#define ARRAY_SIZE(__a) (sizeof(__a) / sizeof(__a[0]))
