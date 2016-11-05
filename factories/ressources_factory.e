note
	description: "Ancestor to every factories that are used to load ressources."
	author: "Louis Marchand"
	date: "Sat, 05 Nov 2016 03:19:48 +0000"
	revision: "0.1"

deferred class
	RESSOURCES_FACTORY

feature {NONE} -- Initialization

	make(a_preference_directory:READABLE_STRING_GENERAL)
			-- Initialization of `Current'
		do
			ressources_directory := {STRING_32}"ressources/"
--			ressources_directory := a_preference_directory.to_string_32 + {STRING_32}"/ressources/"
		end

feature {NONE} -- Constants

	ressources_directory:STRING_32
			-- The directory to find the ressources (image and sound)

	Cards_directory:STRING_32
			-- The directory to find the {CARD} images
		once
			Result := Ressources_directory + {STRING_32}"cards/"
		end

	Boards_directory:STRING_32
			-- The directory to find the {BOARD} images
		once
			Result := Ressources_directory + {STRING_32}"boards/"
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
