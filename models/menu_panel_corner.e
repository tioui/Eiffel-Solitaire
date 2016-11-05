note
	description: "Corner (delimiter) of the {MENU_PANEL}"
	author: "Louis Marchand"
	date: "Sat, 05 Nov 2016 03:19:48 +0000"
	revision: "0.1"

class
	MENU_PANEL_CORNER

inherit
	DIMENSION_MUTABLE_DRAWABLE

create
	make_top_left,
	make_top,
	make_top_right,
	make_left,
	make_right,
	make_bottom_left,
	make_bottom,
	make_bottom_right

feature {NONE} -- Initialization

	make_top_left(a_image_factory:IMAGE_FACTORY)
			-- Initialization of `Current' as situated at top left using `a_image_factory' as `image_factory'
		do
			is_top := True
			is_left := True
			make(a_image_factory)
		end

	make_top(a_image_factory:IMAGE_FACTORY)
			-- Initialization of `Current' as situated at top left using `a_image_factory' as `image_factory'
		do
			is_top := True
			make(a_image_factory)
		end

	make_top_right(a_image_factory:IMAGE_FACTORY)
			-- Initialization of `Current' as situated at top left using `a_image_factory' as `image_factory'
		do
			is_top := True
			is_right := True
			make(a_image_factory)
		end

	make_left(a_image_factory:IMAGE_FACTORY)
			-- Initialization of `Current' as situated at top left using `a_image_factory' as `image_factory'
		do
			is_left := True
			make(a_image_factory)
		end

	make_right(a_image_factory:IMAGE_FACTORY)
			-- Initialization of `Current' as situated at top left using `a_image_factory' as `image_factory'
		do
			is_right := True
			make(a_image_factory)
		end

	make_bottom_left(a_image_factory:IMAGE_FACTORY)
			-- Initialization of `Current' as situated at top left using `a_image_factory' as `image_factory'
		do
			is_bottom := True
			is_left := True
			make(a_image_factory)
		end

	make_bottom(a_image_factory:IMAGE_FACTORY)
			-- Initialization of `Current' as situated at top left using `a_image_factory' as `image_factory'
		do
			is_bottom := True
			make(a_image_factory)
		end

	make_bottom_right(a_image_factory:IMAGE_FACTORY)
			-- Initialization of `Current' as situated at top left using `a_image_factory' as `image_factory'
		do
			is_bottom := True
			is_right := True
			make(a_image_factory)
		end


feature -- Access

	is_top:BOOLEAN
			-- `Current' is situated at the top of the {MENU_PANEL}

	is_left:BOOLEAN
			-- `Current' is situated at the left of the {MENU_PANEL}

	is_bottom:BOOLEAN
			-- `Current' is situated at the bottom of the {MENU_PANEL}

	is_right:BOOLEAN
			-- `Current' is situated at the right of the {MENU_PANEL}

	reload_image
			-- <Precursor>
		local
			l_is_loaded:BOOLEAN
		do
			l_is_loaded := False
			if is_top then
				if is_left then
					image_factory.get_menu_top_left
					l_is_loaded := True
				elseif is_right then
					image_factory.get_menu_top_right
					l_is_loaded := True
				else
					image_factory.get_menu_top
					l_is_loaded := True
				end
			elseif is_bottom then
				if is_left then
					image_factory.get_menu_bottom_left
					l_is_loaded := True
				elseif is_right then
					image_factory.get_menu_bottom_right
					l_is_loaded := True
				else
					image_factory.get_menu_bottom
					l_is_loaded := True
				end
			else
				if is_left then
					image_factory.get_menu_left
					l_is_loaded := True
				elseif is_right then
					image_factory.get_menu_right
					l_is_loaded := True
				end
			end
			if l_is_loaded and attached image_factory.image_informations as la_info then
				set_image_informations (la_info)
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
