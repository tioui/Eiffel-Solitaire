note
	description: "{ENGINE} for the Freecell game."
	author: "Louis Marchand"
	date: "Mon, 15 Aug 2016 02:52:52 +0000"
	revision: "0.1"

class
	FREECELL_ENGINE

inherit
	COMMON_CARD_GAME_ENGINE

create
	make


feature {NONE} -- Implementation

	prepare_cards
			-- <Precursor>
		local
			l_deck:DECK[COMMON_CARD]
		do
			l_deck := deck_factory.any_cards_without_jocker
			l_deck.shuffle (10)
			l_deck.finish
			across 1 |..| 4 as la_index1 loop
				if attached board.get_deck_slot_from_identifier (Tableau_slots.at(la_index1.item)) as la_deck_slot then
					across 1 |..| 7 as la_index2 loop
						l_deck.item.show
						la_deck_slot.deck.extend(l_deck.item)
						l_deck.remove
						l_deck.finish
					end
					la_deck_slot.deck.last.show
				end
			end
			across 5 |..| 8 as la_index1 loop
				if attached board.get_deck_slot_from_identifier (Tableau_slots.at(la_index1.item)) as la_deck_slot then
					across 1 |..| 6 as la_index2 loop
						l_deck.item.show
						la_deck_slot.deck.extend(l_deck.item)
						l_deck.remove
						l_deck.finish
					end
					la_deck_slot.deck.last.show
				end
			end
			check All_Card_Passed: l_deck.is_empty end
		end

	prepare_board
			-- <Precursor>
		do
			board.width := 1674
			board.height := 1010
			across 1 |..| 4 as la_index loop
				board.add_standard_deck_slot (35 + ((la_index.item - 1) * 208), 31, Free_slots.at(la_index.item))
				board.last_added_deck_slot.is_draggable := True
				board.last_added_deck_slot.can_receive_drag := True
				board.last_added_deck_slot.is_double_clickable := True
			end
			board.add_diamond_deck_slot (867, 31, Diamond_slot)
			board.last_added_deck_slot.can_receive_drag := True
			board.add_club_deck_slot (1075, 31, Club_slot)
			board.last_added_deck_slot.can_receive_drag := True
			board.add_heart_deck_slot (1283, 31, Heart_slot)
			board.last_added_deck_slot.can_receive_drag := True
			board.add_spade_deck_slot (1491, 31, Spade_slot)
			board.last_added_deck_slot.can_receive_drag := True
			across 1 |..| 8 as la_index loop
				board.add_standard_deck_slot (35 + ((la_index.item - 1) * 208), 344, Tableau_slots.at(la_index.item))
				board.last_added_deck_slot.is_draggable := True
				board.last_added_deck_slot.can_receive_drag := True
				board.last_added_deck_slot.is_double_clickable := True
				board.last_added_deck_slot.is_expanded_vertically := True
			end
		end

	free_slots_count:INTEGER
			-- The number of Free slot that are without a card
		do
			Result := 0
			across free_slots as la_slot_identifiers loop
				if
					attached board.get_deck_slot_from_identifier (la_slot_identifiers.item)
					as la_slot
				then
					if la_slot.deck.is_empty then
						Result := Result + 1
					end
				end
			end
		end

	can_drag(a_deck_slot:COMMON_DECK_SLOT; a_index:INTEGER; a_deck:DECK[COMMON_CARD]):BOOLEAN
			-- <Precursor>
		local
			l_old:INTEGER
			l_old_red:BOOLEAN
		do
			Result := False
			if free_slots.has (a_deck_slot.identifier) then
				Result := True
			elseif Tableau_slots.has(a_deck_slot.identifier) then
				Result := True
				across a_deck.new_cursor.reversed as la_deck loop
					if
						l_old /~ 0 and then
						(la_deck.item.value /~ l_old + 1 or
						la_deck.item.is_red ~ l_old_red)
					then
						Result := False
					end
					l_old := la_deck.item.value
					l_old_red := la_deck.item.is_red
				end
				if Result then
					Result := a_deck.count <= free_slots_count + 1
				end
			end
		end

	can_drop_final_slot(a_deck, a_dragging_deck:DECK[COMMON_CARD]):BOOLEAN
			-- The `can_drop' routine for Final Slot only (Heart, Club, Diamond and Spade)
		do
			Result := (
						(a_dragging_deck.count ~ 1 and a_deck.count > 0) and then
							a_dragging_deck.first.value ~ a_deck.last.value + 1
						) or (
							(a_dragging_deck.count ~ 1 and a_deck.count ~ 0) and then
							a_dragging_deck.first.value ~ 1
						)
		end

	can_drop(a_deck_slot:COMMON_DECK_SLOT; a_dragging_deck:DECK[COMMON_CARD]):BOOLEAN
			-- <Precursor>
		do
			Result := False
			if a_deck_slot.identifier ~ Diamond_slot then
				Result := a_dragging_deck.first.is_diamond and can_drop_final_slot(a_deck_slot.deck, a_dragging_deck)
			elseif a_deck_slot.identifier ~ Heart_slot then
				Result := a_dragging_deck.first.is_heart and can_drop_final_slot(a_deck_slot.deck, a_dragging_deck)
			elseif a_deck_slot.identifier ~ Spade_slot then
				Result := a_dragging_deck.first.is_spade and can_drop_final_slot(a_deck_slot.deck, a_dragging_deck)
			elseif a_deck_slot.identifier ~ Club_slot then
				Result := a_dragging_deck.first.is_club and can_drop_final_slot(a_deck_slot.deck, a_dragging_deck)
			elseif free_slots.has (a_deck_slot.identifier) then
				if attached board.get_deck_slot_from_identifier (a_deck_slot.identifier) as la_slot then
					Result := a_dragging_deck.count ~ 1 and la_slot.deck.is_empty
				end
			elseif Tableau_slots.has (a_deck_slot.identifier) then
				if a_deck_slot.deck.is_empty then
					Result := a_dragging_deck.first.value ~ 13
				else
					Result := (
									a_deck_slot.deck.last.value ~ a_dragging_deck.first.value + 1
								) and (
									(a_deck_slot.deck.last.is_red and a_dragging_deck.first.is_black)
									or
									(a_deck_slot.deck.last.is_black and a_dragging_deck.first.is_red)
								)
				end
			end
		end

	after_drop(
			a_from_slot:COMMON_DECK_SLOT; a_destination_slot:COMMON_DECK_SLOT; a_dragging_deck:DECK[COMMON_CARD]
		)
			-- <Precursor>
		do
		end

	manage_click(a_slot:COMMON_DECK_SLOT; a_index:INTEGER)
			-- <Precursor>
		do
		end

	manage_double_click(a_slot:COMMON_DECK_SLOT; a_index:INTEGER)
			-- <Precursor>
		local
			l_slot_identifier:INTEGER
			l_slot:COMMON_DECK_SLOT
			l_value:INTEGER
		do
			if not a_slot.deck.is_empty and then a_index ~ a_slot.deck.count then
				if a_slot.deck.last.is_heart then
					l_slot_identifier := Heart_slot
				elseif a_slot.deck.last.is_diamond then
					l_slot_identifier := Diamond_slot
				elseif a_slot.deck.last.is_spade then
					l_slot_identifier := Spade_slot
				elseif a_slot.deck.last.is_club then
					l_slot_identifier := Club_slot
				else
					l_slot_identifier := 0
				end
				if attached board.get_deck_slot_from_identifier (l_slot_identifier) as la_slot then
					l_value := la_slot.deck.count
					if a_slot.deck.at (a_index).value = l_value + 1 then
						create l_slot.make_not_showed (context.image_factory)
						a_slot.deck.finish
						l_slot.set_coordinates (a_slot.deck.item.x, a_slot.deck.item.y)
						l_slot.deck.extend (a_slot.deck.item)
						a_slot.deck.remove
						move_deck_slot_to_deck_slot_fast (l_slot, la_slot, 100)
					end
				end
			end
		end

feature {NONE} -- Constants

	Free1_slot:INTEGER = 1
			-- {DECK_SLOT}.`identifier' for the First Free slot {DECK}

	Free2_slot:INTEGER = 2
			-- {DECK_SLOT}.`identifier' for the First Free slot {DECK}

	Free3_slot:INTEGER = 3
			-- {DECK_SLOT}.`identifier' for the First Free slot {DECK}

	Free4_slot:INTEGER = 4
			-- {DECK_SLOT}.`identifier' for the First Free slot {DECK}

	Free_slots:ARRAYED_LIST[INTEGER]
			-- {DECK_SLOT}.`identifier' for the every Free Slots {DECK}
		once
			create Result.make_from_array (<<
										Free1_slot,
										Free2_slot,
										Free3_slot,
										Free4_slot
									>>)
		end

	Diamond_slot:INTEGER = 5
			-- {DECK_SLOT}.`identifier' for the Diamond {DECK}

	Club_slot:INTEGER = 6
			-- {DECK_SLOT}.`identifier' for the Club {DECK}

	Heart_slot:INTEGER = 7
			-- {DECK_SLOT}.`identifier' for the Heart {DECK}

	Spade_slot:INTEGER = 8
			-- {DECK_SLOT}.`identifier' for the Spade {DECK}

	Tableau1_slot:INTEGER = 9
			-- {DECK_SLOT}.`identifier' for the first tableau {DECK}

	Tableau2_slot:INTEGER = 10
			-- {DECK_SLOT}.`identifier' for the second tableau {DECK}

	Tableau3_slot:INTEGER = 11
			-- {DECK_SLOT}.`identifier' for the third tableau {DECK}

	Tableau4_slot:INTEGER = 12
			-- {DECK_SLOT}.`identifier' for the forth tableau {DECK}

	Tableau5_slot:INTEGER = 13
			-- {DECK_SLOT}.`identifier' for the fifth tableau {DECK}

	Tableau6_slot:INTEGER = 14
			-- {DECK_SLOT}.`identifier' for the sixth tableau {DECK}

	Tableau7_slot:INTEGER = 15
			-- {DECK_SLOT}.`identifier' for the seventh tableau {DECK}

	Tableau8_slot:INTEGER = 16
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
										Tableau7_slot,
										Tableau8_slot
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
