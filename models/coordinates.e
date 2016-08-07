note
	description: "Class that contain coordinates position (x, y)"
	author: "Louis Marchand"
	date: "Mon, 01 Aug 2016 21:17:25 +0000"
	revision: "0.1"

class
	COORDINATES

create
	default_create,
	set_coordinates

feature -- Access

	set_coordinates(a_x, a_y:INTEGER)
			-- Initialization of `Current' using `a_x' as `x' and `a_y' as `y'
		do
			x := a_x
			y := a_y
		end

	x:INTEGER assign set_x
			-- The horizontal coordinate of `Current'

	y:INTEGER assign set_y
			-- The vertical coordinate of `Current'

	set_x(a_x:INTEGER)
			-- Assign `a_x' to `x'
		do
			x := a_x
		ensure
			Is_Assign: x ~ a_x
		end

	set_y(a_y:INTEGER)
			-- Assign `a_y' to `y'
		do
			y := a_y
		ensure
			Is_Assign: y ~ a_y
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
