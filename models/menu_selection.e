note
	description: "The selection indicator to highlight selected {MENU_ITEM} in menus"
	author: "Louis Marchand"
	date: "Sat, 05 Nov 2016 03:19:48 +0000"
	revision: "0.1"

class
	MENU_SELECTION

inherit
	DIMENSION_MUTABLE_DRAWABLE

create
	make_left,
	make_center,
	make_right

feature {NONE} -- Initialization

	make_left(a_image_factory:IMAGE_FACTORY)
			-- Initialization of a left `Current' using `a_image_factory' as `image_factory'
		do
			is_left := True
			make(a_image_factory)
		end

	make_center(a_image_factory:IMAGE_FACTORY)
			-- Initialization of a center `Current' using `a_image_factory' as `image_factory'
		do
			is_center := True
			make(a_image_factory)
		end

	make_right(a_image_factory:IMAGE_FACTORY)
			-- Initialization of a right `Current' using `a_image_factory' as `image_factory'
		do
			is_right := True
			make(a_image_factory)
		end

feature -- Access

	is_left:BOOLEAN
			-- `Current' represent a left selection part

	is_center:BOOLEAN
			-- `Current' represent a center selection part

	is_right:BOOLEAN
			-- `Current' represent a right selection part

	reload_image
			-- <Precursor>
		do
			if is_center then
				image_factory.get_menu_select_center

			elseif is_left then
				image_factory.get_menu_select_left
			else
				image_factory.get_menu_select_right
			end
			if attached image_factory.image_informations as la_information then
				set_image_informations (la_information)
			end
		end

invariant
	Is_Part_Valid: is_left or is_right or is_center

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
