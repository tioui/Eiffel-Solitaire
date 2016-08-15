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
			make, deck_factory, board, deck_converter, dragging_slot, slot_converter
		end

feature {NONE}

	make(a_context:CONTEXT)
			-- <Precursor>
		do
			Precursor(a_context)
			create deck_factory.make (context.image_factory)
			create board.make (context.image_factory)
			create {COMMON_CARD_BACK}card_back.make(context.image_factory)
			create dragging_slot.make_not_showed (context.image_factory)
			dragging_slot.is_expanded_vertically := True
		end

feature -- Access

	deck_factory:COMMON_DECK_FACTORY
			-- <Precursor>

	board:COMMON_CARD_BOARD
			-- <Precursor>

	dragging_slot:COMMON_DECK_SLOT
			-- <Precursor>

feature {NONE} -- Implementation

	deck_converter(a_deck:DECK[CARD]):DECK[COMMON_CARD]
			-- <Precursor>
		do
			if attached {DECK[COMMON_CARD]}a_deck as la_deck then
				Result := la_deck
			else
				create Result.make
				across a_deck as la_deck loop
					if attached {COMMON_CARD}la_deck.item as la_card then
						Result.extend (la_card)
					end
				end
			end
		end

	slot_converter(a_slot:DECK_SLOT):COMMON_DECK_SLOT
			-- Convert `a_slot' to the correct type of {CARD} for `Current'
		do
			if attached {COMMON_DECK_SLOT}a_slot as la_slot then
				Result := la_slot
			else
				create Result.make_from_other (a_slot)
			end
		end

	can_drag(a_deck_slot:COMMON_DECK_SLOT; a_index:INTEGER; a_deck:DECK[COMMON_CARD]):BOOLEAN
			-- <Precursor>
		deferred
		end

	can_drop(a_deck_slot:COMMON_DECK_SLOT; a_dragging_deck:DECK[COMMON_CARD]):BOOLEAN
			-- <Precursor>
		deferred
		end

	after_drop(a_from_slot:COMMON_DECK_SLOT; a_destination_slot:COMMON_DECK_SLOT; a_dragging_deck:DECK[COMMON_CARD])
			-- <Precursor>
		deferred
		end

	manage_click(a_slot:COMMON_DECK_SLOT; a_index:INTEGER)
			-- <Precursor>
		deferred
		end

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
