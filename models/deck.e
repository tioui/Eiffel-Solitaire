note
	description: "A pack of {CARD}."
	author: "Louis Marchand"
	date: "Sat, 30 Jul 2016 20:35:07 +0000"
	revision: "0.1"

class
	DECK[G -> CARD]

inherit
	LINKED_LIST[G]
	GAME_RANDOM_SHARED
		undefine
			is_equal, copy
		end

create
	make

feature -- Access

	remove_i_th(a_index:INTEGER)
			-- Remove the element at index `a_index'.
		require
			valid_key: valid_index (a_index)
		local
			l_pos: CURSOR
		do
			l_pos := cursor
			go_i_th (a_index)
			remove
			if valid_cursor(l_pos) then
				go_to (l_pos)
			end
		end

	shuffle(a_number:INTEGER)
			-- Randomize the content of `Current' `a_number' of time
		do
			across 1 |..| a_number as la_index loop
				from
					start
				until
					exhausted
				loop
					random.generate_new_random
					swap (random.last_random_integer_between (1, count))
					forth
				end
			end
		end

	cut:TUPLE[top, bottom:like Current]
			-- Split `Current' in two {DECK} of random size return them
			-- One or both those {DECK}s can be empty
		local
			l_pos: CURSOR
			l_cut:INTEGER
			l_top, l_bottom:like Current
		do
			random.generate_new_random
			l_cut := (random.last_random_integer_between (0, count + 1))
			l_pos := cursor
			start
			l_top := sub_deck (l_cut)
			go_i_th (l_cut + 1)
			l_bottom := sub_deck (count)
			go_to (l_pos)
			Result := [l_top, l_bottom]
		end

	sub_deck (a_count: INTEGER_32): DECK [G]
			-- Copy of sub-deck beginning at current position
			-- and having min (`a_count`, `from_here`) items,
			-- where `from_here` is the number of items
			-- at or to the right of current position.
		require
			not_off_unless_after: off implies after
			valid_subchain: a_count >= 0
		local
			l_pos: CURSOR
			l_counter: INTEGER_32
		do
			from
				create Result.make
				if object_comparison then
					Result.compare_objects
				end
				l_pos := cursor
			until
				(l_counter = a_count) or else exhausted
			loop
				Result.extend (item)
				forth
				l_counter := l_counter + 1
			end
			go_to (l_pos)
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
