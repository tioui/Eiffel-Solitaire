note
	description: "A {DRAWABLE} showing a item of a menu."
	author: "Louis Marchand"
	date: "Mon, 14 Nov 2016 02:57:39 +0000"
	revision: "0.1"

class
	MENU_ITEM_DRAWABLE

inherit
	IMAGE_DRAWABLE
		rename
			make as make_image_drawable
		end

	MENU_ITEM

create
	make

feature {NONE} -- Initialisation

	make(a_image_factory:IMAGE_FACTORY; a_image:GAME_TEXTURE; a_action:PROCEDURE)
			-- Initialisation of `Current' using `a_image_factory' as `image_factory', `a_image' as `image' and
			-- `a_action' as `action'
		do
			make_image_drawable(a_image_factory, a_image)
			is_selectable:= True
			action := a_action
		end

feature -- Access

	action:PROCEDURE
			-- What to do when the user click on `Current'

invariant
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
