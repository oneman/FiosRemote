#    This file is part of VAG202.
#
#    VAG202 is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    VAG202 is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with VAG202.  If not, see <http://www.gnu.org/licenses/>.

require "vhash.rb"

v = Vhash.find_by_output(ARGV.shift.gsub(" ", ""))
v.show
