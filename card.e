note
	description: "Represent a playing card"
	author: "Louis Marchand"
	date: "Sat, 30 Jul 2016 20:35:07 +0000"
	revision: "0.1"

deferred class
	CARD

inherit
	DRAWABLE
		rename
			make as make_drawable
		redefine
			is_equal
		end

feature
	make(a_value:INTEGER; a_factory:IMAGE_FACTORY)
			-- Initialization of `Current' using `a_value' as `value' and `a_factory' as `image_factory'
		do
			value := a_value
			make_drawable(a_factory)
		end
feature -- Access

	value:INTEGER
			-- The worth of `Current'

	minimum_value:INTEGER
			-- The minimum number that `value' can hold
		deferred
		end

	maximum_value:INTEGER
			-- The maximum number that `value' can hold
		deferred
		end

	is_face_up:BOOLEAN
			-- Is `Current' visible

	hide
			-- Unset `is_face_up'
		do
			is_face_up := False
		ensure
			Face_Down: not is_face_up
		end

	show
			-- Set `is_face_up'
		do
			is_face_up := True
		ensure
			Face_Up: is_face_up
		end

	turn
			-- Toggle `is_face_up'
		do
			is_face_up := not is_face_up
		ensure
			Face_Toggled: is_face_up ~ not old is_face_up
		end

feature -- Comparison

	is_equal(a_other: like Current): BOOLEAN
			-- <Precursor>
		do
			Result := value ~ a_other.value
		end

invariant
	Value_Valid: value >= minimum_value and value <= maximum_value
	
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
