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

#include <sstream>
#include <vector>
#include <gtest/gtest.h>

#include "EmulateFixture.h"
#include "Flags.h"
#include "Arithmetic.h"

static const std::vector<struct ArithmeticTest<uint8_t>> and8_tests = {
    {0, 0, 0, PF | ZF, false}, {0xf, 0xf, 0x0f, PF, false},
        {0x0f, 0xf0, 0x0, PF | ZF, false}, {0x0f, 0x01, 0x01, 0, false},
};

static const std::vector<struct ArithmeticTest<uint16_t>> and16_tests = {
    {0, 0, 0, PF | ZF, false}, {0xf, 0xf, 0x0f, PF, false},
        {0x000f, 0xf000, 0x0, PF | ZF, false},
        {0xf00f, 0xf000, 0xf000, PF | SF, false}, {0x0f, 0x01, 0x01, 0, false},
        {0x0240, 0x3c84, 0x0, PF | ZF, false},
};

INSTANTIATE_TEST_CASE_P(And,
                        ArithmeticRegReg8Test,
                        ::testing::Values(
                            // and al, bl
                            Arith8Params({0x20, 0xd8}, and8_tests)));

INSTANTIATE_TEST_CASE_P(And,
                        ArithmeticMemReg8Test,
                        ::testing::Values(
                            // and [bx], al
                            Arith8Params({0x20, 0x07}, and8_tests)));

INSTANTIATE_TEST_CASE_P(And,
                        ArithmeticRegReg8TestReversed,
                        ::testing::Values(
                            // and bl, al
                            Arith8Params({0x22, 0xd8}, and8_tests)));

INSTANTIATE_TEST_CASE_P(And,
                        ArithmeticMemReg8TestReversed,
                        ::testing::Values(
                            // and al, [bx]
                            Arith8Params({0x22, 0x07}, and8_tests)));

INSTANTIATE_TEST_CASE_P(And,
                        ArithmeticRegReg16Test,
                        ::testing::Values(
                            // and ax, bx
                            Arith16Params({0x21, 0xd8}, and16_tests)));

INSTANTIATE_TEST_CASE_P(And,
                        ArithmeticRegMem16Test,
                        ::testing::Values(
                            // adc [bx], ax
                            Arith16Params({0x21, 0x07}, and16_tests)));

INSTANTIATE_TEST_CASE_P(And,
                        ArithmeticRegReg16TestReversed,
                        ::testing::Values(
                            // and bx, ax
                            Arith16Params({0x23, 0xd8}, and16_tests)));

INSTANTIATE_TEST_CASE_P(And,
                        ArithmeticMemReg16TestReversed,
                        ::testing::Values(
                            // and ax, bx
                            Arith16Params({0x23, 0x07}, and16_tests)));

INSTANTIATE_TEST_CASE_P(And,
                        ArithmeticRegImmed8Test,
                        ::testing::Values(
                            // and bl, 1
                            ArithImmed8Params(std::vector<uint8_t>{0x80, 0xe3,
                                                                   0x01},
                                              {1, 1, 0, false})));

INSTANTIATE_TEST_CASE_P(And,
                        ArithmeticMemImmed8Test,
                        ::testing::Values(
                            // and byte [bx], 1
                            ArithImmed8Params(std::vector<uint8_t>{0x80, 0x27,
                                                                   0x01},
                                              {1, 1, 0, false})));

INSTANTIATE_TEST_CASE_P(And,
                        ArithmeticRegImmed16Test,
                        ::testing::Values(
                            // and bx, 1
                            ArithImmed16Params(std::vector<uint8_t>{0x81, 0xe3,
                                                                    0x01, 0x0},
                                               {1, 1, 0, false})));

INSTANTIATE_TEST_CASE_P(And,
                        ArithmeticMemImmed16Test,
                        ::testing::Values(
                            // and wandd [bx], 1
                            ArithImmed16Params(std::vector<uint8_t>{0x81, 0x27,
                                                                    0x01, 0x00},
                                               {1, 1, 0, false})));

INSTANTIATE_TEST_CASE_P(
    And,
    ArithmeticRegImmed16TestExtend,
    ::testing::Values(
        // and bx, 1
        ArithImmed16Params(std::vector<uint8_t>{0x83, 0xe3, 0x01},
                           {0x0101, 1, 0, false}),
        // and bx, -1
        ArithImmed16Params(std::vector<uint8_t>{0x83, 0xe3, 0xff},
                           {0x0101, 0x0101, 0, false})));

INSTANTIATE_TEST_CASE_P(
    And,
    ArithmeticMemImmed16TestExtend,
    ::testing::Values(
        // and [bx], 1
        ArithImmed16Params(std::vector<uint8_t>{0x83, 0x27, 0x01},
                           {0x0101, 1, 0, false}),
        // and [bx], -1
        ArithImmed16Params(std::vector<uint8_t>{0x83, 0x27, 0xff},
                           {0x0101, 0x0101, 0, false})));

INSTANTIATE_TEST_CASE_P(And,
                        ArithmeticAlImmedTest,
                        ::testing::Values(
                            // and al, 1
                            ArithImmed8Params(std::vector<uint8_t>{0x24, 0x01},
                                              {1, 1, 0, false})));

INSTANTIATE_TEST_CASE_P(And,
                        ArithmeticAxImmedTest,
                        ::testing::Values(
                            // and ax, 1
                            ArithImmed16Params(std::vector<uint8_t>{0x25, 0x01,
                                                                    0x0},
                                               {1, 1, 0, false})));
