# Copyright Jamie Iles, 2017
#
# This file is part of s80x86.
#
# s80x86 is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# s80x86 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with s80x86.  If not, see <http://www.gnu.org/licenses/>.

import os
import sys
from py8086sim.Cpu import GPR

from Runner import Runner

class MovesRunner(Runner):
    binary = 'moves.bin'

    def setup(self):
        self.write_reg(GPR.IP, 1024)

    def validate_result(self):
        self.assert_mem_equal(0, 0x1234, 0xabcd, width=16)
        self.assert_reg_equal(GPR.AX, 0xabcd)
        self.assert_mem_equal(0, 0x007e, 0xabcd, width=16)

MovesRunner(sys.argv[1]).run()
