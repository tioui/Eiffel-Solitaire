note
	description: "A {BACKGROUND} containing only one color"
	author: "Louis Marchand"
	date: "Mon, 01 Aug 2016 21:17:25 +0000"
	revision: "0.1"

class
	COLOR_BACKGROUND

inherit
	BACKGROUND

create
	make

feature {NONE} -- Initialization

	make(a_color:GAME_COLOR)
			-- Initialization of `Current' using `a_color' as `color'
		do
			color := a_color
		ensure
			Is_Color_Assign: color ~ a_color
		end
feature -- Access

	draw(a_renderer:GAME_RENDERER)
			-- <Precursor>
		local
			l_old_color:GAME_COLOR
		do
			l_old_color := a_renderer.drawing_color
			a_renderer.set_drawing_color (color)
			a_renderer.clear
			a_renderer.set_drawing_color (l_old_color)
		end

	color:GAME_COLOR
			-- The color to `draw' on `Current'

invariant
	
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
