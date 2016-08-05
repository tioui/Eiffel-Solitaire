note
	description: "Singleton to access every unique ressources of the system"
	author: "Louis Marchand"
	date: "Mon, 01 Aug 2016 21:17:25 +0000"
	revision: "0.1"

class
	CONTEXT

inherit
	ERROR_MANAGER
		redefine
			default_create
		end

feature {NONE} -- Implementation

	default_create
			-- Initialization of `Current'
		local
			l_window_builder:GAME_WINDOW_RENDERED_BUILDER
		do
			Precursor
			create l_window_builder
			l_window_builder.enable_resizable
			window := l_window_builder.generate_window
			if window.has_error then
				set_error ({STRING_32}"Cannot generate a Window.")
			end
			create image_factory.make (window.renderer)
			if image_factory.has_error then
				set_error (image_factory.error_message)
			end
		end
feature -- Access

	window:GAME_WINDOW_RENDERED
			-- The OS window to draw the scene

	image_factory:IMAGE_FACTORY
			-- The factory used to generate {DRAWABLE}.`image'

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
