note
	description: "A {DRAWABLE}, but with the `width' and `height' writable"
	author: "Louis Marchand"
	date: "Sat, 05 Nov 2016 03:19:48 +0000"
	revision: "0.1"

deferred class
	DIMENSION_MUTABLE_DRAWABLE

inherit
	DRAWABLE
		export
			{ANY} set_width, set_height
		end

note
	license: "[
		    Copyright (C) 2016 Louis Marchand

		    This program is free software: you can redistribute it and/or modify
		    it under the terms of the GNU General Public License as published by
		    the Free Software Foundation, either version 3 of the License, or
		    (at your option) any later version.

		    This program is distributed in the hope that it will be useful,
		    but WITHOUT ANY WARRANTY; without even the implied warranty of
		    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		    GNU General Public License for more details.

		    You should have received a copy of the GNU General Public License
		    along with this program.  If not, see <http://www.gnu.org/licenses/>.
		]"

end
