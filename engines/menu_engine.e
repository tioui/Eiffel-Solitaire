note
	description: "{ENGINE} that managed menus"
	author: "Louis Marchand"
	date: "Sat, 05 Nov 2016 03:19:48 +0000"
	revision: "0.1"

deferred class
	MENU_ENGINE

inherit
	MENU_ITEM_ENGINE
		redefine
			make, redraw_scene
		end

feature {NONE} -- Initialization

	make_with_background(a_context:CONTEXT; a_background:BACKGROUND)
			-- Initialization of `Current' using `a_context' as `context' and `a_background' as `backgrund'
		do
			make(a_context)
			background := a_background
		end

	make(a_context:CONTEXT)
			-- <Precursor>
		do
			is_horizontal := False
			background := a_context.image_factory.board_background
			Precursor(a_context)
		end

feature -- Access

	redraw_scene
			-- <Precursor>
		do
			background.draw (context.window.renderer)
			Precursor
		end

	background:BACKGROUND
			-- The image to show behind `Current'
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
