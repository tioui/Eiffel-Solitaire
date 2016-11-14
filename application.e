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
	TEXT_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_context:detachable CONTEXT
			l_printer:LOCALIZED_PRINTER
		do
			game_library.enable_video
			image_file_library.enable_png
			text_library.enable_text
			create l_context
			if not l_context.has_error then
				run_engines(l_context)
			else
				create l_printer
				l_printer.localized_print_error (("An error occured: " + l_context.error_message + "%N"))
			end
			l_context := Void
			game_library.clear_all_events
			text_library.quit_library
			image_file_library.quit_library
			game_library.quit_library
		end

	run_engines(a_context:CONTEXT)
			-- Run the engines
		local
			l_engine:ENGINE
			l_game_engine:detachable GAME_ENGINE
			l_must_quit:BOOLEAN
			l_memory:MEMORY
			l_must_continue:BOOLEAN
		do
			l_must_continue := False
			create l_memory
			from
				create {MAIN_MENU}l_engine.make_new (a_context)
				l_must_quit := False
			until
				l_engine.has_error or l_must_quit
			loop
				if l_must_continue then
					l_engine.resume
					l_must_continue := False
				else
					l_engine.run
				end
				l_must_quit := l_engine.quit_signal_received
				if not l_must_quit then
					if attached {MAIN_MENU} l_engine as la_engine then
						if attached la_engine.game_selected as la_game then
							l_engine := la_game
						else
							if (la_engine.must_restart or la_engine.must_continue) and attached l_game_engine as la_game_engine then
								l_engine := la_game_engine
								if la_engine.must_continue then
									l_must_continue := True
								end
							end
						end
					elseif attached {GAME_ENGINE} l_engine as la_engine then
						if la_engine.is_menu_requested then
							l_game_engine := la_engine
							l_engine := main_menu_from_game_engine(a_context, la_engine)
						end
					end
				end
			end
		end

	main_menu_from_game_engine(a_context:CONTEXT;a_game_engine:GAME_ENGINE):MAIN_MENU
			-- Create a {MAIN_MENU} from a `a_game_engine'
		local
			l_background:IMAGE_BACKGROUND
		do
			create l_background.make (a_game_engine.scene_image)
			create Result.make_from_game (a_context, l_background)
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
