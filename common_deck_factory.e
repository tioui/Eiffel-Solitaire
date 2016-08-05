note
	description: "Factory to create {DECK} of {COMMON_CARD}"
	author: "Louis Marchand"
	date: "Sat, 30 Jul 2016 20:35:07 +0000"
	revision: "0.1"

class
	COMMON_DECK_FACTORY

inherit
	DECK_FACTORY
	COMMON_CARD_CONSTANTS


create
	make

feature -- Access

	any_cards:DECK[like card]
			-- Create a {DECK} with every cards (including 2 jockers)
		do
			Result := any_cards_without_jocker
			Result.merge_right (joker_cards)
		ensure
			Count_Valid: Result.count ~ 54
			Unicity:
				across 1 |..| 53 as la_index1 all
					across (la_index1.item + 1) |..| 54 as la_index2 all
						Result.at (la_index1.item) /~ Result.at (la_index2.item)
					end
				end
			Completion:
					across 1 |..| 13 as la_index1 all
						across 1 |..| 4 as la_index2 all
							across Result as la_result some
								la_result.item.value ~ la_index1.item and la_result.item.suit ~ la_index2.item
							end
						end
					end
				and
					across Result as la_result some
						la_result.item.is_low_joker
					end
				and
					across Result as la_result some
						la_result.item.is_high_joker
					end
		end

	any_cards_without_jocker:DECK[like card]
			-- Create a {DECK} with every cards (excluding the 2 jockers)
		do
			Result := any_heart_cards
			Result.merge_right (any_diamond_cards)
			Result.merge_right (any_club_cards)
			Result.merge_right (any_spade_cards)
		ensure
			Count_Valid: Result.count ~ 52
			Unicity:
				across 1 |..| 51 as la_index1 all
					across (la_index1.item + 1) |..| 52 as la_index2 all
						Result.at (la_index1.item) /~ Result.at (la_index2.item)
					end
				end
			Completion:
				across 1 |..| 13 as la_index1 all
					across 1 |..| 4 as la_index2 all
						across Result as la_result some
							la_result.item.value ~ la_index1.item and la_result.item.suit ~ la_index2.item
						end
					end
				end
		end

	any_heart_cards:DECK[like card]
			-- Create a {DECK} with every heart cards
		do
			Result := any_cards_for_suit(Heart_suit)
		ensure
			Count_Valid: Result.count ~ 13
			Suit_Valid: across Result as la_result all la_result.item.is_heart end
			Unicity:
				across 1 |..| 12 as la_index1 all
					across (la_index1.item + 1) |..| 13 as la_index2 all
						Result.at (la_index1.item) /~ Result.at (la_index2.item)
					end
				end
			Completion:
				across 1 |..| 13 as la_index1 all
					across Result as la_result some
						la_result.item.value ~ la_index1.item
					end
				end
		end

	any_diamond_cards:DECK[like card]
			-- Create a {DECK} with every diamond cards
		do
			Result := any_cards_for_suit(Diamond_suit)
		ensure
			Count_Valid: Result.count ~ 13
			Suit_Valid: across Result as la_result all la_result.item.is_diamond end
			Unicity:
				across 1 |..| 12 as la_index1 all
					across (la_index1.item + 1) |..| 13 as la_index2 all
						Result.at (la_index1.item) /~ Result.at (la_index2.item)
					end
				end
			Completion:
				across 1 |..| 13 as la_index1 all
					across Result as la_result some
						la_result.item.value ~ la_index1.item
					end
				end
		end

	any_spade_cards:DECK[like card]
			-- Create a {DECK} with every spade cards
		do
			Result := any_cards_for_suit(spade_suit)
		ensure
			Count_Valid: Result.count ~ 13
			Suit_Valid: across Result as la_result all la_result.item.is_spade end
			Unicity:
				across 1 |..| 12 as la_index1 all
					across (la_index1.item + 1) |..| 13 as la_index2 all
						Result.at (la_index1.item) /~ Result.at (la_index2.item)
					end
				end
			Completion:
				across 1 |..| 13 as la_index1 all
					across Result as la_result some
						la_result.item.value ~ la_index1.item
					end
				end
		end

	any_club_cards:DECK[like card]
			-- Create a {DECK} with every club cards
		do
			Result := any_cards_for_suit(Club_suit)
		ensure
			Count_Valid: Result.count ~ 13
			Suit_Valid: across Result as la_result all la_result.item.is_club end
			Unicity:
				across 1 |..| 12 as la_index1 all
					across (la_index1.item + 1) |..| 13 as la_index2 all
						Result.at (la_index1.item) /~ Result.at (la_index2.item)
					end
				end
			Completion:
				across 1 |..| 13 as la_index1 all
					across Result as la_result some
						la_result.item.value ~ la_index1.item
					end
				end
		end

	any_cards_for_suit(a_suit:INTEGER):DECK[like card]
			-- Create a {DECK} with every cards of the `a_suit'
		require
			Suit_Valid: a_suit >= 1 and a_suit <= 4
		do
			create Result.make
			across 1 |..| 13 as la_value loop
				Result.extend (card(la_value.item, a_suit))
			end
		ensure
			Count_Valid: Result.count ~ 13
			Suit_Valid: across Result as la_result all la_result.item.suit ~ a_suit end
			Unicity:
				across 1 |..| 12 as la_index1 all
					across (la_index1.item + 1) |..| 13 as la_index2 all
						Result.at (la_index1.item) /~ Result.at (la_index2.item)
					end
				end
			Completion:
				across 1 |..| 13 as la_index1 all
					across Result as la_result some
						la_result.item.value ~ la_index1.item
					end
				end
		end

	joker_cards:DECK[like card]
			-- Create a {DECK} with the 2 joker cards
		do
			create Result.make
			across 1 |..| 2 as la_index loop
				Result.extend (card(la_index.item, 5))
			end
		ensure
			Count_Valid: Result.count ~ 2
			Completion:
					across Result as la_result some la_result.item.is_low_joker end
				and
					across Result as la_result some la_result.item.is_high_joker end
		end

feature {NONE} -- Implementation

	card(a_value, a_suit:INTEGER):COMMON_CARD
			-- Creating a new {CARD} using `a_value' as {CARD}.`value' and `a_suit' as {CARD}.`a_suit'
		require
			Value_Valid: a_value >= 1 and a_value <= 15
			Suit_Valid: a_suit >= 1 and a_suit <= 5
			Jocker_Valid: a_suit ~ 5 implies (a_value >= 1 and a_value <= 2)
		do
			create Result.make(a_value, a_suit, image_factory)
		ensure
			Value_Assign: Result.value ~ a_value
			Suit_Assign: Result.suit ~ a_suit
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
