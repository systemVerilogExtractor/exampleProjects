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

// add r, r/m, 8-bit
void EmulatorPimpl::add00()
{
    modrm_decoder->set_width(OP_WIDTH_8);
    modrm_decoder->decode();

    uint8_t v1 = read_data<uint8_t>();
    uint8_t v2 = registers->get(modrm_decoder->reg());

    uint8_t result;
    uint16_t flags;
    std::tie(flags, result) = do_add<uint8_t>(v1, v2);

    registers->set_flags(flags, OF | SF | ZF | AF | CF | PF);
    write_data<uint8_t>(result & 0xff);
}

// add r, r/m, 16-bit
void EmulatorPimpl::add01()
{
    modrm_decoder->set_width(OP_WIDTH_16);
    modrm_decoder->decode();

    uint16_t v1 = read_data<uint16_t>();
    uint16_t v2 = registers->get(modrm_decoder->reg());

    uint16_t result, flags;
    std::tie(flags, result) = do_add<uint16_t>(v1, v2);

    registers->set_flags(flags, OF | SF | ZF | AF | CF | PF);
    write_data<uint16_t>(result & 0xffff);
}

// add r/m, r, 8-bit
void EmulatorPimpl::add02()
{
    modrm_decoder->set_width(OP_WIDTH_8);
    modrm_decoder->decode();

    uint8_t v1 = read_data<uint8_t>();
    uint8_t v2 = registers->get(modrm_decoder->reg());

    uint8_t result;
    uint16_t flags;
    std::tie(flags, result) = do_add<uint8_t>(v1, v2);

    registers->set_flags(flags, OF | SF | ZF | AF | CF | PF);
    registers->set(modrm_decoder->reg(), result & 0xff);
}

// add r/m, r, 16-bit
void EmulatorPimpl::add03()
{
    modrm_decoder->set_width(OP_WIDTH_16);
    modrm_decoder->decode();

    uint16_t v1 = read_data<uint16_t>();
    uint16_t v2 = registers->get(modrm_decoder->reg());

    uint16_t result;
    uint16_t flags;
    std::tie(flags, result) = do_add<uint16_t>(v1, v2);

    registers->set_flags(flags, OF | SF | ZF | AF | CF | PF);
    registers->set(modrm_decoder->reg(), result & 0xffff);
}

void EmulatorPimpl::add04()
{
    auto v1 = registers->get(AL);
    auto v2 = fetch_byte();
    uint8_t result;
    uint16_t flags;
    std::tie(flags, result) = do_add<uint8_t>(v1, v2);

    registers->set_flags(flags, OF | SF | ZF | AF | CF | PF);
    registers->set(AL, result);
}

void EmulatorPimpl::add05()
{
    auto v1 = registers->get(AX);
    auto v2 = fetch_16bit();
    uint16_t result;
    uint16_t flags;
    std::tie(flags, result) = do_add<uint16_t>(v1, v2);

    registers->set_flags(flags, OF | SF | ZF | AF | CF | PF);
    registers->set(AX, result);
}
