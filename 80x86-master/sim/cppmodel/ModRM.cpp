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

#include "ModRM.h"

#include <cassert>

ModRMDecoder::ModRMDecoder(std::function<uint8_t()> get_byte,
                           const RegisterFile *registers)
    : get_byte(get_byte), registers(registers), width(OP_WIDTH_16), modrm(0)
{
}

void ModRMDecoder::clear()
{
    is_decoded = false;
}

void ModRMDecoder::decode()
{
    is_decoded = true;
    modrm = get_byte();
    // Cache the address now, we need to process all mod/rm bytes +
    // displacements before the opcode handler starts reading immediates etc.
    addr_is_cached = false;
    if (rm_type() == OP_MEM)
        effective_address();
}

OperandType ModRMDecoder::rm_type() const
{
    assert(is_decoded);
    return (modrm & 0xc0) == 0xc0 ? OP_REG : OP_MEM;
}

void ModRMDecoder::set_width(OperandWidth width)
{
    this->width = width;
}

GPR ModRMDecoder::reg() const
{
    assert(is_decoded);
    auto reg = raw_reg();

    if (width == OP_WIDTH_8)
        return static_cast<GPR>(static_cast<int>(AL) + reg);

    return static_cast<GPR>(static_cast<int>(AX) + reg);
}

int ModRMDecoder::raw_reg() const
{
    assert(is_decoded);
    return (modrm >> 3) & 0x7;
}

GPR ModRMDecoder::rm_reg() const
{
    assert(is_decoded);
    assert(rm_type() == OP_REG);

    int reg = (modrm >> 0) & 0x7;

    if (width == OP_WIDTH_8)
        return static_cast<GPR>(static_cast<int>(AL) + reg);

    return static_cast<GPR>(static_cast<int>(AX) + reg);
}

uint16_t ModRMDecoder::effective_address()
{
    assert(is_decoded);
    if (addr_is_cached)
        return cached_address;

    cached_address = calculate_effective_address();
    addr_is_cached = true;

    return cached_address;
}

uint16_t ModRMDecoder::calculate_effective_address()
{
    assert(rm_type() == OP_MEM);
    assert(modrm >> 6 != 0x03);

    switch ((modrm >> 6) & 0x3) {
    case 0x00: return mod00();
    case 0x01: return mod01();
    case 0x02: return mod10();
    }

    __builtin_unreachable();
}

uint16_t ModRMDecoder::mod00()
{
    switch (modrm & 0x7) {
    case 0x0: return registers->get(BX) + registers->get(SI);
    case 0x1: return registers->get(BX) + registers->get(DI);
    case 0x2: return registers->get(BP) + registers->get(SI);
    case 0x3: return registers->get(BP) + registers->get(DI);
    case 0x4: return registers->get(SI);
    case 0x5: return registers->get(DI);
    case 0x6:
        return static_cast<uint16_t>(get_byte()) |
               (static_cast<uint16_t>(get_byte()) << 8);
    case 0x7: return registers->get(BX);
    }
    __builtin_unreachable();
}

uint16_t ModRMDecoder::mod01()
{
    auto displacement = static_cast<int8_t>(get_byte());
    switch (modrm & 0x7) {
    case 0x0: return registers->get(BX) + registers->get(SI) + displacement;
    case 0x1: return registers->get(BX) + registers->get(DI) + displacement;
    case 0x2: return registers->get(BP) + registers->get(SI) + displacement;
    case 0x3: return registers->get(BP) + registers->get(DI) + displacement;
    case 0x4: return registers->get(SI) + displacement;
    case 0x5: return registers->get(DI) + displacement;
    case 0x6: return registers->get(BP) + displacement;
    case 0x7: return registers->get(BX) + displacement;
    }
    __builtin_unreachable();
}

uint16_t ModRMDecoder::mod10()
{
    auto displacement = static_cast<int16_t>(get_byte()) |
                        (static_cast<uint16_t>(get_byte()) << 8);
    switch (modrm & 0x7) {
    case 0x0: return registers->get(BX) + registers->get(SI) + displacement;
    case 0x1: return registers->get(BX) + registers->get(DI) + displacement;
    case 0x2: return registers->get(BP) + registers->get(SI) + displacement;
    case 0x3: return registers->get(BP) + registers->get(DI) + displacement;
    case 0x4: return registers->get(SI) + displacement;
    case 0x5: return registers->get(DI) + displacement;
    case 0x6: return registers->get(BP) + displacement;
    case 0x7: return registers->get(BX) + displacement;
    }
    __builtin_unreachable();
}

bool ModRMDecoder::uses_bp_as_base() const
{
    if (!is_decoded)
        return false;

    if (rm_type() != OP_MEM)
        return false;

    auto mod = modrm >> 6;
    auto rm = modrm & 0x7;

    if (mod == 0)
        return rm == 0x2 || rm == 0x3;

    return rm == 0x2 || rm == 0x3 || rm == 0x6;
}
