note
	description: "An {ENGINE} to execute {COMMON_CARD} games"
	author: "Louis Marchand"
	date: "Mon, 01 Aug 2016 21:17:25 +0000"
	revision: "0.1"

deferred class
	COMMON_CARD_GAME_ENGINE

inherit
	CARD_GAME_ENGINE
		redefine
			make, deck_factory, board, dragging_deck
		end

feature {NONE}

	make(a_context:CONTEXT)
			-- <Precursor>
		do
			Precursor(a_context)
			create deck_factory.make (context.image_factory)
			create board.make (context.image_factory)
			create {COMMON_CARD_BACK}card_back.make(context.image_factory)
			create dragging_deck.make
		end

feature -- Access

	deck_factory:COMMON_DECK_FACTORY
			-- <Precursor>

	board:COMMON_CARD_BOARD
			-- <Precursor>

	dragging_deck:DECK[COMMON_CARD]
			-- <Precursor>

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
