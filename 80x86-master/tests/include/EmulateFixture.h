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

#include <memory>
#include <vector>
#include <gtest/gtest.h>

#include <cassert>
#include "CPU.h"
#include "TestUtils.h"

extern std::unique_ptr<CPU> get_cpu(const std::string &test_name);

class DummyIO : public IOPorts
{
public:
    DummyIO(uint16_t addr, size_t num_ports) : IOPorts(addr, num_ports), val(0)
    {
    }

    uint8_t read8(uint16_t port_num, unsigned offs)
    {
        (void)port_num;
        return (val >> (offs * 8)) & 0xff;
    }

    uint16_t read16(uint16_t port_num)
    {
        (void)port_num;
        return val;
    }

    void write8(uint16_t port_num, unsigned offs, uint8_t v)
    {
        (void)port_num;
        uint16_t mask = 0xff << (8 * offs);

        val &= ~mask;
        val |= (static_cast<uint16_t>(v) << (8 * offs));

        write_vals.push_back(static_cast<uint16_t>(v) << (8 * offs));
    }

    void write16(uint16_t port_num, uint16_t v)
    {
        (void)port_num;
        val = v;

        write_vals.push_back(v);
    }

    std::vector<uint16_t> get_write_vals() const
    {
        return write_vals;
    }

private:
    uint16_t val;
    std::vector<uint16_t> write_vals;
};

class EmulateFixture : public ::testing::Test
{
public:
    EmulateFixture()
        : cpu(get_cpu(current_test_name())),
          io100(0x100, 1),
          io80(0x80, 1),
          io10(0x10, 1)
    {
        add_ioport(&io100);
        add_ioport(&io80);
        add_ioport(&io10);
        reset();
    }

    ~EmulateFixture()
    {
        cpu->write_coverage();
    }

    void add_ioport(IOPorts *p)
    {
        cpu->add_ioport(p);
    }

    void reset()
    {
        cpu->reset();
        // Doesn't need to model the reset vector of FFF0:0000 otherwise we
        // need to handle wrapping around to 0.  Just start off away from the
        // interrupt vector table so we can easily detect interrupts.
        cpu->write_reg(CS, 0x0000);
        cpu->write_reg(IP, 0x1000);
        cpu->write_reg(SS, 0x2000);
        cpu->write_reg(ES, 0x4000);
        cpu->write_reg(DS, 0x6000);
    }

    void set_instruction(const std::vector<uint8_t> &instr)
    {
        auto cs = cpu->read_reg(CS);
        auto ip = cpu->read_reg(IP);
        cpu->write_vector8(cs, ip, instr);
        // jmp to self, prevent wandering off into garbage
        cpu->write_mem16(cs, ip + instr.size(), 0xfeeb);
        instr_len = instr.size();
        // Force a prefetch fifo clear so we don't end up executing what was
        // there before we wrote this instruction.
        cpu->write_reg(IP, ip);
    }

    void write_reg(GPR regnum, uint16_t val)
    {
        cpu->write_reg(regnum, val);
    }

    uint16_t read_reg(GPR regnum)
    {
        return cpu->read_reg(regnum);
    }

    void write_mem8(uint16_t addr, uint8_t val, GPR segment = DS)
    {
        cpu->write_mem8(cpu->read_reg(segment), addr, val);
    }
    void write_mem16(uint16_t addr, uint16_t val, GPR segment = DS)
    {
        cpu->write_mem16(cpu->read_reg(segment), addr, val);
    }
    void write_mem32(uint16_t addr, uint32_t val, GPR segment = DS)
    {
        cpu->write_mem32(cpu->read_reg(segment), addr, val);
    }

    void write_cstring(uint16_t addr, const char *str, GPR segment = DS)
    {
        do {
            write_mem8(addr++, *str++, segment);
        } while (*str);
        write_mem8(addr, 0, segment);
    }

    void write_vector8(uint16_t addr,
                       std::vector<uint8_t> vec,
                       GPR segment = DS)
    {
        for (auto v : vec) {
            write_mem8(addr, v, segment);
            ++addr;
        }
    }
    void write_vector16(uint16_t addr,
                        std::vector<uint16_t> vec,
                        GPR segment = DS)
    {
        for (auto v : vec) {
            write_mem16(addr, v, segment);
            addr += sizeof(uint16_t);
        }
    }

    std::string read_cstring(uint16_t addr, GPR segment = DS)
    {
        std::string str;

        char v;
        for (;;) {
            v = read_mem8(addr++, segment);
            if (!v)
                break;
            str += v;
        }

        return str;
    }

    uint8_t read_mem8(uint16_t addr, GPR segment = DS)
    {
        return cpu->read_mem8(cpu->read_reg(segment), addr);
    }
    uint16_t read_mem16(uint16_t addr, GPR segment = DS)
    {
        return cpu->read_mem16(cpu->read_reg(segment), addr);
    }
    uint32_t read_mem32(uint16_t addr, GPR segment = DS)
    {
        return cpu->read_mem32(cpu->read_reg(segment), addr);
    }

    void write_io8(uint32_t addr, uint8_t val)
    {
        cpu->write_io8(addr, val);
    }
    void write_io16(uint32_t addr, uint16_t val)
    {
        cpu->write_io16(addr, val);
    }

    uint8_t read_io8(uint32_t addr)
    {
        return cpu->read_io8(addr);
    }
    uint16_t read_io16(uint32_t addr)
    {
        return cpu->read_io16(addr);
    }

    void emulate(int count = 1, bool check_length = true)
    {
        cpu->clear_side_effects();

        assert(count > 0);
        size_t len = 0;
        for (auto i = 0; i < count; ++i)
            len += cpu->step();
        if (cpu->has_instruction_length() && check_length)
            ASSERT_EQ(len, instr_len);
    }

    void wait_for_int_yield()
    {
        while (!cpu->int_yield_ready())
            cpu->cycle_cpu();
    }

    void write_flags(uint16_t val)
    {
        cpu->write_flags(val);
    }

    uint16_t read_flags()
    {
        return cpu->read_flags();
    }

    bool instruction_had_side_effects()
    {
        return cpu->instruction_had_side_effects();
    }

    void raise_nmi()
    {
        cpu->raise_nmi();
    }

    void raise_irq(int irq_num)
    {
        cpu->raise_irq(irq_num);
    }

protected:
    size_t instr_len;
    std::unique_ptr<CPU> cpu;
    DummyIO io100;
    DummyIO io80;
    DummyIO io10;
};
