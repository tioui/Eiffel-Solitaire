note
	description: "An {ANIMATION} used to move {DECK} of {CARD} around"
	author: "Louis Marchand"
	date: "Sun, 07 Aug 2016 15:09:15 +0000"
	revision: "0.1"

class
	DECK_SLOT_MOVING_ANIMATION

inherit
	MOVING_ANIMATION
		rename
			make as make_animation
		end

create
	make

feature {NONE} -- Initialization

	make(a_moving, a_to:DECK_SLOT; a_to_coordinates:COORDINATES; a_from_timestamp, a_to_timestamp:NATURAL)
			-- Initialization of `Current' using `a_moving' as `moving' and `from_coordinates',
			-- `a_to' as `to_coordinates', `a_from_timestamp' as `timestamp' and `from_timestamp'
			-- and `a_to_timestamp' as `to_timestamp'
		require
			From_Lower_Than_To: a_from_timestamp < a_to_timestamp
		do
			moving_deck_slot := a_moving
			destintation_deck_slot := a_to
			make_animation(a_moving, a_to_coordinates, a_from_timestamp, a_to_timestamp)
		ensure
			Is_Moving_Assign: moving.x ~ a_moving.x and moving.y ~ a_moving.y
			Is_From_Assign: from_coordinates.x ~ a_moving.x and from_coordinates.y ~ a_moving.y
			Is_To_Empty_Coordinates_Assign: to_coordinates.x ~ a_to_coordinates.x and to_coordinates.y ~ a_to_coordinates.y
			Is_From_Timestamp_Assign: from_timestamp ~ a_from_timestamp
			Is_Timestamp_Assign: timestamp ~ a_from_timestamp
			Is_To_Timestamp_Assign: to_timestamp ~ a_to_timestamp
			Is_Moving_Deck_Slot: moving_deck_slot ~ a_moving
			Is_Destination_Deck_Slot: destintation_deck_slot ~ a_to
		end

feature -- Access

	moving_deck_slot:DECK_SLOT
			-- The {DECK_SLOT} that is moving

	destintation_deck_slot:DECK_SLOT
			-- The {DECK_SLOT} that is the destination

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
