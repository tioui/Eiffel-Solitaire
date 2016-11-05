note
	description: "{ENGINE} for the Klondike (3 cards) game."
	author: "Louis Marchand"
	date: "Mon, 08 Aug 2016 18:38:40 +0000"
	revision: "0.1"

class
	KLONDIKE_3_ENGINE

inherit
	KLONDIKE_ENGINE
		redefine
			prepare_board,
			manage_reload_click
		end

create
	make

feature {NONE} -- Implementation

	prepare_board
			-- <Precursor>
		do
			Precursor
			if attached board.get_deck_slot_from_identifier (Waste_slot) as la_deck_slot then
				la_deck_slot.is_expanded_horizontally := True
				la_deck_slot.expanded_count := 3
			end
		end

	manage_reload_click(a_reload_slot, a_waste_slot:COMMON_DECK_SLOT)
			-- <Precursor>
		do
			if a_reload_slot.deck.is_empty then
				Precursor(a_reload_slot, a_waste_slot)
			else
				across 1 |..| 3 as la_index loop
					if not a_reload_slot.deck.is_empty then
						Precursor(a_reload_slot, a_waste_slot)
					end
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
