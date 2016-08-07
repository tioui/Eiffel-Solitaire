note
	description: "Ancestor of every object that manage error."
	author: "Louis Marchand"
	date: "Mon, 01 Aug 2016 21:17:25 +0000"
	revision: "0.1"

deferred class
	ERROR_MANAGER

inherit
	ANY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- Initialization of `Current'
		do
			has_error := False
			error_message := {STRING_32}""
		end

feature -- Access

	has_error:BOOLEAN
			-- An error occured on the last feature call of `Current'

	error_message:READABLE_STRING_GENERAL
			-- If `has_error' is set, this is the description of the error

	clear_error
			-- Remove every error from `Current'
		do
			has_error := False
		end

feature {NONE} -- Implemetation

	set_error(a_message:READABLE_STRING_GENERAL)
			-- If `has_error' is not set, set `has_error' and assign `a_message' to `error_message'
		do
			if not has_error then
				has_error := True
				error_message := a_message
			end
		ensure
			Is_Assign: has_error
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
