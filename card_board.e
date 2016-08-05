note
	description: "A playing surface for card games"
	author: "Louis Marchand"
	date: "Mon, 01 Aug 2016 21:17:25 +0000"
	revision: "0.1"

class
	CARD_BOARD

inherit
	BOARD
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (a_factory: IMAGE_FACTORY)
			-- <Precursor>
		do
			Precursor(a_factory)
			create {LINKED_LIST[DECK_SLOT]}deck_slots.make
		end

feature -- Access

	deck_slots:LIST[DECK_SLOT]
			-- Every slot that can be used to put a {DECK} of {CARD}

	add_deck_slot(a_x, a_y:INTEGER; a_identifier:INTEGER; a_deck_slot:DECK_SLOT)
			-- Add a new `a_deck_slot' in `deck_slots' at position (`a_x',`a_y') idetified by `a_identifier'
		do
			a_deck_slot.set_identifier (a_identifier)
			a_deck_slot.set_x (a_x)
			a_deck_slot.set_y (a_y)
			deck_slots.extend (a_deck_slot)
		end

	add_not_showed_deck_slot(a_x, a_y:INTEGER; a_identifier:INTEGER)
			-- Add a new unshowed {DECK_SLOT} in `deck_slots' at position (`a_x',`a_y') idetified by `a_identifier'
		local
			l_slot:DECK_SLOT
		do
			create l_slot.make_not_showed (image_factory)
			add_deck_slot(a_x, a_y, a_identifier, l_slot)
		end

	add_standard_deck_slot(a_x, a_y:INTEGER; a_identifier:INTEGER)
			-- Add a standard {DECK_SLOT} in `deck_slots' at position (`a_x',`a_y') idetified by `a_identifier'
		local
			l_slot:DECK_SLOT
		do
			create l_slot.make_standard (image_factory)
			add_deck_slot(a_x, a_y, a_identifier, l_slot)
		end

	add_reload_deck_slot(a_x, a_y:INTEGER; a_identifier:INTEGER)
			-- Add a new reload {DECK_SLOT} in `deck_slots' at position (`a_x',`a_y') idetified by `a_identifier'
		local
			l_slot:DECK_SLOT
		do
			create l_slot.make_reload (image_factory)
			add_deck_slot(a_x, a_y, a_identifier, l_slot)
		end

	get_deck_slot_from_identifier(a_identifier:INTEGER):detachable DECK_SLOT
		do
			across deck_slots as la_slot loop
				if la_slot.item.identifier ~ a_identifier then
					Result := la_slot.item
				end
			end
		end

	last_added_deck_slot:DECK_SLOT
			-- The last {DECK_SLOT} that has been added by a `add_*_deck_slot'
		require
			Not_Empty: not deck_slots.is_empty
		do
			Result := deck_slots.last
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
