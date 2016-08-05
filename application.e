note
	description: "The solitaire game root class"
	author: "Louis Marchand"
	date: "Mon, 01 Aug 2016 21:17:25 +0000"
	revision: "0.1"

class
	APPLICATION

inherit
	GAME_LIBRARY_SHARED
	IMG_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_engine:KLONDIKE_ENGINE
			l_context:CONTEXT
			l_printer:LOCALIZED_PRINTER
		do
			game_library.enable_video
			image_file_library.enable_png
			create l_context
			if not l_context.has_error then
				create l_engine.make (l_context)
				if not l_engine.has_error then
					l_engine.run
				end
			else
				create l_printer
				l_printer.localized_print_error (("An error occured: " + l_context.error_message + "%N"))
			end
			game_library.clear_all_events
			game_library.quit_library
			image_file_library.quit_library
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
