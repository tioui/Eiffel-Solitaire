note
	description: "[
				Represent a common playing card
				Common playing card have 4 suits (heart, diamond, club and spade)
				and every suit have 13 cards from 1 (or Ace) to 10, a Jack, a Queen and
				a King. There is also 2 Joker cards.
			]"
	author: "Louis Marchand"
	date: "Sat, 30 Jul 2016 20:35:07 +0000"
	revision: "0.1"

class
	COMMON_CARD

inherit
	CARD
		rename
			make as make_with_value
		redefine
			is_equal
		end
	COMMON_CARD_CONSTANTS
		redefine
			is_equal
		end

create
	make

feature {NONE} -- Initialization

	make(a_value, a_suit:INTEGER; a_factory:IMAGE_FACTORY)
			-- Initialization of `Current' using `a_value' as `value' and `a_suit' as `suit'
		require
			Value_Valid: a_value >= 1 and a_value <= 13
			Suit_Valid: a_suit >= 1 and a_suit <= 5
			Jocker_Valid: a_suit ~ 5 implies (a_value >= 1 and a_value <= 2)
		do
			suit := a_suit
			make_with_value(a_value, a_factory)
		ensure
			Value_Assign: value ~ a_value
			Suit_Assign: suit ~ a_suit
		end

feature -- Access

	reload_image
			-- Reload the `image'. To use when another pack of {CARD} is
			-- loaded in `image_factory'
		do
			image_factory.get_common_card (value, suit)
			if attached image_factory.image_informations as la_info then
				set_image_informations(la_info)
			end
		end

	is_1, is_ace:BOOLEAN
			-- Is `Current' is an Ace
		do
			Result := value ~ 1
		end

	is_2:BOOLEAN
			-- Is `Current' is a 2
		do
			Result := value ~ 2
		end

	is_3:BOOLEAN
			-- Is `Current' is a 3
		do
			Result := value ~ 3
		end

	is_4:BOOLEAN
			-- Is `Current' is a 4
		do
			Result := value ~ 4
		end

	is_5:BOOLEAN
			-- Is `Current' is a 5
		do
			Result := value ~ 5
		end

	is_6:BOOLEAN
			-- Is `Current' is a 6
		do
			Result := value ~ 6
		end

	is_7:BOOLEAN
			-- Is `Current' is a 7
		do
			Result := value ~ 7
		end

	is_8:BOOLEAN
			-- Is `Current' is a 8
		do
			Result := value ~ 8
		end

	is_9:BOOLEAN
			-- Is `Current' is a 9
		do
			Result := value ~ 9
		end

	is_10:BOOLEAN
			-- Is `Current' is a 10
		do
			Result := value ~ 10
		end

	is_jack:BOOLEAN
			-- Is `Current' is a Jack
		do
			Result := value ~ 11
		end

	is_queen:BOOLEAN
			-- Is `Current' is a Queen
		do
			Result := value ~ 12
		end

	is_kink:BOOLEAN
			-- Is `Current' is a King
		do
			Result := value ~ 13
		end

	is_low_joker:BOOLEAN
			-- Is `Current' is a the lower Joker
		do
			Result := is_joker and value ~ 1
		end

	is_high_joker:BOOLEAN
			-- Is `Current' is the higher Joker
		do
			Result := is_joker and value ~ 2
		end

	is_joker:BOOLEAN
			-- Is `Current' is the higher Joker
		do
			Result := suit ~ 5
		end

	suit:INTEGER
			-- The type of he card (1 -> Heart, 2 -> Diamond, 3 -> Club and 4 -> Spade)

	is_heart:BOOLEAN
			-- The `suit' of `Current' is Heart
		do
			Result := suit = Heart_suit
		end

	is_diamond:BOOLEAN
			-- The `suit' of `Current' is Diamond
		do
			Result := suit = Diamond_suit
		end

	is_red:BOOLEAN
			-- The `suit' of `Current' is a red one (Heart or Diamond)
		do
			Result := is_heart or is_diamond
		ensure
			Is_Valid: (
						(is_heart or is_diamond) implies Result
					) and (
						Result implies (is_heart or is_diamond)
					)
		end

	is_black:BOOLEAN
			-- The `suit' of `Current' is a black one (Club or Spade)
		do
			Result := is_spade or is_club
		ensure
			Is_Valid: (
						(is_spade or is_club) implies Result
					) and (
						Result implies (is_spade or is_club)
					)
		end

	is_club:BOOLEAN
			-- The `suit' of `Current' is Club
		do
			Result := suit = Club_suit
		end

	is_spade:BOOLEAN
			-- The `suit' of `Current' is Spade
		do
			Result := suit = Spade_suit
		end

	minimum_value:INTEGER = 1
			-- <Precursor>

	maximum_value:INTEGER = 13
			-- <Precursor>

feature -- Comparison

	is_equal(a_other: like Current): BOOLEAN
			-- <Precursor{CARD}>
		do
			Result := Precursor{CARD}(a_other) and suit ~ a_other.suit
		end

invariant
	Value_Valid: value >= 1 and value <= 13
	Suit_Valid: suit >= 1 and suit <= 5
	Joker_Valid: suit ~ 5 implies (value >= 1 and value <= 2)
	Red_Valid: (
					(is_heart or is_diamond) implies is_red
				) and (
					is_red implies (is_heart or is_diamond)
				)
	Black_Valid: (
					(is_spade or is_club) implies is_black
				) and (
					is_black implies (is_spade or is_club)
				)
	Black_Not_Red: is_black implies not is_red
	Red_Not_Black: is_red implies not is_black

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
