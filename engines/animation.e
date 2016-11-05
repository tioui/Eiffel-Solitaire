note
	description: "Manage a moving image"
	author: "Louis Marchand"
	date: "Sun, 07 Aug 2016 15:09:15 +0000"
	revision: "0.1"

deferred class
	ANIMATION

feature -- Access

	from_timestamp:NATURAL
			-- The starting time of `Current'

	to_timestamp:NATURAL
			-- The ending time of `Current'

	timestamp:NATURAL
			-- The time of the last call of `update'

	update(a_timestamp:NATURAL)
			-- move `Current' forward using `a_timestamp' as new `timestamp'
		require
			Not_Done: not is_done
		deferred
		ensure
			Is_Assign: timestamp ~ a_timestamp
		end

	is_done:BOOLEAN
			-- `Current' has finnish runnning
		do
			Result := timestamp >= to_timestamp
		end

invariant
	From_Lower_Than_To: from_timestamp < to_timestamp
	Is_Done_Valid: (timestamp >= to_timestamp implies is_done) and (is_done implies timestamp >= to_timestamp)

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
