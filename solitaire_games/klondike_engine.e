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
			l_deck:DECK[COMMON_CARD]
		do
			l_deck := deck_factory.any_cards_without_jocker
			l_deck.shuffle (10)
			if attached board.get_deck_slot_from_identifier (Reload_slot) as la_deck_slot then
				la_deck_slot.deck := l_deck
			end
			l_deck.finish
			across 1 |..| 7 as la_index1 loop
				if attached board.get_deck_slot_from_identifier (Tableau_slots.at(la_index1.item)) as la_deck_slot then
					across 1 |..| la_index1.item as la_index2 loop
						la_deck_slot.deck.extend(l_deck.item)
						l_deck.remove
						l_deck.finish
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
			board.last_added_deck_slot.is_draggable := True
			board.last_added_deck_slot.is_count_visible := True
			board.last_added_deck_slot.is_double_clickable := True
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
				board.last_added_deck_slot.is_draggable := True
				board.last_added_deck_slot.is_expanded_vertically := True
				board.last_added_deck_slot.can_receive_drag := True
				board.last_added_deck_slot.is_double_clickable := True
			end
		end

	can_drag(a_deck_slot:COMMON_DECK_SLOT; a_index:INTEGER; a_deck:DECK[COMMON_CARD]):BOOLEAN
			-- <Precursor>
		do
			Result := False
			if tableau_slots.has (a_deck_slot.identifier) then
				Result := a_deck.first.is_face_up
			elseif a_deck_slot.identifier ~ Waste_slot and a_deck.count ~ 1 then
				Result := True
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
			if tableau_slots.has (a_from_slot.identifier) then
				if a_from_slot.deck.count > 0 then
					a_from_slot.deck.last.show
				end
			end
		end

	manage_click(a_slot:COMMON_DECK_SLOT; a_index:INTEGER)
			-- <Precursor>
		do
			if
				a_slot.identifier ~ Reload_slot and
				attached board.get_deck_slot_from_identifier (Waste_slot) as la_slot
			then
				manage_reload_click(a_slot, la_slot)
			end
		end

	manage_reload_click(a_reload_slot, a_waste_slot:COMMON_DECK_SLOT)
			-- Launched when the user has clicked on the Reload {DECK_SLOT}
		require
			Reload_Slot_Valid: a_reload_slot.identifier ~ Reload_slot
			Waste_Slot_Valid: a_waste_slot.identifier ~ Waste_slot
		local
			l_card:COMMON_CARD
			l_waste_deck:DECK[COMMON_CARD]
			l_temporary_slot:COMMON_DECK_SLOT
		do
			create l_temporary_slot.make_not_showed (context.image_factory)
			l_waste_deck := a_waste_slot.deck
			if a_reload_slot.deck.is_empty then
				from
					l_waste_deck.finish
				until
					l_waste_deck.exhausted
				loop
					l_waste_deck.item.hide
					l_temporary_slot.deck.extend (l_waste_deck.item)
					l_waste_deck.back
				end
				l_waste_deck.wipe_out
				l_temporary_slot.is_count_visible := True
				l_temporary_slot.set_coordinates (a_waste_slot.x, a_waste_slot.y)
				move_deck_slot_to_deck_slot_fast (l_temporary_slot, a_reload_slot, 50)
			else
				a_reload_slot.deck.finish
				l_card := a_reload_slot.deck.item
				l_card.show
				a_reload_slot.deck.remove
				l_temporary_slot.deck.extend (l_card)
				l_temporary_slot.set_coordinates (a_reload_slot.x, a_reload_slot.y)
				move_deck_slot_to_deck_slot_fast (l_temporary_slot, a_waste_slot, 50)
			end
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
						a_slot.deck.last.show
					end
				end
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
