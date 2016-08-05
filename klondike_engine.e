note
	description: "{ENGINE} for the Klondike game."
	author: "Louis Marchand"
	date: "Mon, 01 Aug 2016 21:17:25 +0000"
	revision: "0.1"

class
	KLONDIKE_ENGINE

inherit
	COMMON_CARD_GAME_ENGINE

create
	make


feature {NONE} -- Implementation

	prepare_cards
			-- <Precursor>
		local
			l_deck:DECK[CARD]
		do
			l_deck := deck_factory.any_cards_without_jocker
			l_deck.shuffle (10)
			if attached board.get_deck_slot_from_identifier (Reload_slot) as la_deck then
				la_deck.deck := l_deck
			end
			l_deck.start
			across 1 |..| 7 as la_index1 loop
				if attached board.get_deck_slot_from_identifier (Tableau_slots.at(la_index1.item)) as la_deck_slot then
					across 1 |..| la_index1.item as la_index2 loop
						la_deck_slot.deck.extend(l_deck.item)
						l_deck.remove
					end
					la_deck_slot.deck.last.show
				end
			end

		end

	prepare_board
			-- <Precursor>
		do
			board.width := 1626
			board.height := 958
			board.add_reload_deck_slot (35, 31, Reload_slot)
			board.last_added_deck_slot.is_clickable := True
			board.last_added_deck_slot.is_count_visible := True
			board.add_not_showed_deck_slot (267, 31, Waste_slot)
			board.last_added_deck_slot.is_clickable := True
			board.last_added_deck_slot.is_draggable := True
			board.add_diamond_deck_slot (731, 31, Diamond_slot)
			board.last_added_deck_slot.can_receive_drag := True
			board.add_club_deck_slot (963, 31, Club_slot)
			board.last_added_deck_slot.can_receive_drag := True
			board.add_heart_deck_slot (1195, 31, Heart_slot)
			board.last_added_deck_slot.can_receive_drag := True
			board.add_spade_deck_slot (1427, 31, Spade_slot)
			board.last_added_deck_slot.can_receive_drag := True
			across 1 |..| 7 as la_index loop
				board.add_standard_deck_slot (35 + ((la_index.item - 1) * 232), 344, Tableau_slots.at(la_index.item))
				board.last_added_deck_slot.is_clickable := True
				board.last_added_deck_slot.is_draggable := True
				board.last_added_deck_slot.is_expanded := True
				board.last_added_deck_slot.can_receive_drag := True
			end
		end

feature {NONE} -- Constants

	Reload_slot:INTEGER = 1
			-- {DECK_SLOT}.`identifier' for the Reload {DECK}

	Waste_slot:INTEGER = 2
			-- {DECK_SLOT}.`identifier' for the Waste {DECK}

	Diamond_slot:INTEGER = 3
			-- {DECK_SLOT}.`identifier' for the Diamond {DECK}

	Club_slot:INTEGER = 4
			-- {DECK_SLOT}.`identifier' for the Club {DECK}

	Heart_slot:INTEGER = 5
			-- {DECK_SLOT}.`identifier' for the Heart {DECK}

	Spade_slot:INTEGER = 6
			-- {DECK_SLOT}.`identifier' for the Spade {DECK}

	Tableau1_slot:INTEGER = 7
			-- {DECK_SLOT}.`identifier' for the first tableau {DECK}

	Tableau2_slot:INTEGER = 8
			-- {DECK_SLOT}.`identifier' for the second tableau {DECK}

	Tableau3_slot:INTEGER = 9
			-- {DECK_SLOT}.`identifier' for the third tableau {DECK}

	Tableau4_slot:INTEGER = 10
			-- {DECK_SLOT}.`identifier' for the forth tableau {DECK}

	Tableau5_slot:INTEGER = 11
			-- {DECK_SLOT}.`identifier' for the fifth tableau {DECK}

	Tableau6_slot:INTEGER = 12
			-- {DECK_SLOT}.`identifier' for the sixth tableau {DECK}

	Tableau7_slot:INTEGER = 13
			-- {DECK_SLOT}.`identifier' for the seventh tableau {DECK}

	Tableau_slots:ARRAYED_LIST[INTEGER]
			-- {DECK_SLOT}.`identifier' for the every tableau {DECK}
		once
			create Result.make_from_array (<<
										Tableau1_slot,
										Tableau2_slot,
										Tableau3_slot,
										Tableau4_slot,
										Tableau5_slot,
										Tableau6_slot,
										Tableau7_slot
									>>)
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
