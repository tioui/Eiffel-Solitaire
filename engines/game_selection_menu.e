note
	description: "The {MENU_ENGINE} that manage the selection of the game"
	author: "Louis Marchand"
	date: "Sat, 05 Nov 2016 03:19:48 +0000"
	revision: "0.1"

class
	GAME_SELECTION_MENU

inherit
	MENU_ENGINE
		rename
			make as make_new,
			make_with_background as make
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make(a_context:CONTEXT; a_background:BACKGROUND)
			-- <Precursor>
		do
			Precursor(a_context, a_background)
			add_items ("Klondike", agent on_klondike)
			add_items ("Klondike 3 cartes", agent on_klondike3)
			add_items ("Freecell", agent on_freecell)
			add_items ("Retour", agent quit)
		end

feature -- Access

	game_selected:detachable GAME_ENGINE
			-- The game selected in `Current' (if any)

feature {NONE} -- Implementation

	on_klondike
			-- The user select the Klondike game
		do
			create {KLONDIKE_ENGINE}game_selected.make (context)
			quit
		end

	on_klondike3
			-- The user select the Klondike 3 cards game
		do
			create {KLONDIKE_3_ENGINE}game_selected.make (context)
			quit
		end

	on_freecell
			-- The user select the Freecell game
		do
			create {FREECELL_ENGINE}game_selected.make (context)
			quit
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
