note
	description: "A playing surface for common card games"
	author: "Louis Marchand"
	date: "Mon, 01 Aug 2016 21:17:25 +0000"
	revision: "0.1"

class
	COMMON_CARD_BOARD

inherit
	CARD_BOARD

create
	make

feature -- Access

	add_heart_deck_slot(a_x, a_y:INTEGER; a_identifier:INTEGER)
			-- Add a new heart {DECK_SLOT} in `deck_slots' at position (`a_x',`a_y') idetified by `a_identifier'
		local
			l_slot:COMMON_DECK_SLOT
		do
			create l_slot.make_heart (image_factory)
			add_deck_slot(a_x, a_y, a_identifier, l_slot)
		end

	add_diamond_deck_slot(a_x, a_y:INTEGER; a_identifier:INTEGER)
			-- Add a new diamond {DECK_SLOT} in `deck_slots' at position (`a_x',`a_y') idetified by `a_identifier'
		local
			l_slot:COMMON_DECK_SLOT
		do
			create l_slot.make_diamond (image_factory)
			add_deck_slot(a_x, a_y, a_identifier, l_slot)
		end

	add_club_deck_slot(a_x, a_y:INTEGER; a_identifier:INTEGER)
			-- Add a new club {DECK_SLOT} in `deck_slots' at position (`a_x',`a_y') idetified by `a_identifier'
		local
			l_slot:COMMON_DECK_SLOT
		do
			create l_slot.make_club (image_factory)
			add_deck_slot(a_x, a_y, a_identifier, l_slot)
		end

	add_spade_deck_slot(a_x, a_y:INTEGER; a_identifier:INTEGER)
			-- Add a new spade {DECK_SLOT} in `deck_slots' at position (`a_x',`a_y') idetified by `a_identifier'
		local
			l_slot:COMMON_DECK_SLOT
		do
			create l_slot.make_spade (image_factory)
			add_deck_slot(a_x, a_y, a_identifier, l_slot)
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
