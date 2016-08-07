note
	description: "A {DRAWABLE} representing the back of a {COMMON_CARD}."
	author: "Louis Marchand"
	date: "Mon, 01 Aug 2016 21:17:25 +0000"
	revision: "0.1"

class
	COMMON_CARD_BACK

inherit
	CARD_BACK

create
	make

feature -- Access

	reload_image
			-- <Precursor>
		do
			image_factory.get_common_card_back
			if attached image_factory.image_informations as la_info then
				set_image_informations(la_info)
			end
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
