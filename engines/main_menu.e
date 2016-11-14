note
	description: "The {MENU_ENGINE} that manage the common options"
	author: "Louis Marchand"
	date: "Sat, 05 Nov 2016 03:19:48 +0000"
	revision: "0.1"

class
	MAIN_MENU

inherit
	MENU_ENGINE
		rename
			make as make_new,
			make_with_background as make_from_game
		redefine
			make_new, make_from_game, run
		end

create
	make_new,
	make_from_game

feature {NONE} -- Initialization

	make_from_game(a_context:CONTEXT; a_background:BACKGROUND)
			-- <Precursor>
		do
			Precursor(a_context, a_background)
			with_continue := True
			initialize_items
		end

	make_new(a_context:CONTEXT)
			-- <Precursor>
		do
			Precursor(a_context)
			with_continue := False
			initialize_items
		end

	initialize_items
			-- Initialize `items'
		do
			must_restart := False
			must_continue := False
			internal_items.wipe_out
			if with_continue then
				add_items ("Continuer", agent continue)
				add_items ("Recommencer", agent restart)
				add_items ("Changer de jeu", agent change_game)
			else
				add_items ("Choisir un jeu", agent change_game)
			end
			if context.window.is_fullscreen then
				add_items ("Fenetré", agent toggle_fullscreen)
			else
				add_items ("Plein écran", agent toggle_fullscreen)
			end

			add_items ("Quitter", agent on_quit_signal (0))
		end

	initialize_title
			-- <Precursor>
		do
			title := "Menu"
		end

feature -- Access

	game_selected:detachable GAME_ENGINE
			-- The game selected in the {GAME_SELECTION_MENU} (if any)

	must_restart:BOOLEAN
			-- The user ask to restart the presently used game

	must_continue:BOOLEAN
			-- The user ask to continue the presently used game

	run
			-- <Precursor>
		local
			l_must_quit:BOOLEAN
		do
			from
				l_must_quit := False
			until
				l_must_quit
			loop
				is_game_selection_selected := False
				Precursor
				if is_game_selection_selected then
					start_selection_menu
				end
				l_must_quit := attached game_selected or quit_signal_received or has_error or must_continue or must_restart
			end
		end

feature {NONE} -- Implementation

	with_continue:BOOLEAN
			-- Must put a "continue" option in the `items'

	continue
			-- Continue the game presently running
		do
			must_continue := True
			quit
		end

	restart
			-- Restart the game presently running
		do
			must_restart := True
			quit
		end

	toggle_fullscreen
			-- Change to fullscreen or to windowed
		do
			context.toggle_fullscreen
			initialize_items
		end

	change_game
			-- Change the playing game
		do
			is_game_selection_selected := True
			quit
		end

	is_game_selection_selected:BOOLEAN
			-- True if the user ask to select a game

	start_selection_menu
			-- Launch the {GAME_SELECTION_MENU}
		local
			l_engine:GAME_SELECTION_MENU
		do
			create l_engine.make (context, background)
			if l_engine.has_error then
				has_error := True
			else
				l_engine.run
				quit_signal_received := l_engine.quit_signal_received
				if attached l_engine.game_selected as la_game then
					game_selected := la_game
				end
			end

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
