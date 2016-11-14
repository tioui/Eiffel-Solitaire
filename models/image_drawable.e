note
	description: "A {DRAWABLE} showing an entire `image'."
	author: "Louis Marchand"
	date: "Mon, 14 Nov 2016 02:57:39 +0000"
	revision: "0.1"

class
	IMAGE_DRAWABLE

inherit
	DRAWABLE
		rename
			make as make_drawable
		end
create
	make

feature {NONE} -- Initialization

	make(a_image_factory:IMAGE_FACTORY; a_texture:GAME_TEXTURE)
			-- Initialization of `Current' using `a_image_factory' as `image_factory' and `a_texture' as `texture'
		do
			texture := a_texture
			make_drawable(a_image_factory)
		ensure
			Is_Image_Factory_Assign: image_factory ~ a_image_factory
			Is_Texture_Assign: texture ~ a_texture
		end

feature -- Access

	reload_image
			-- <Precursor>
		do
			set_whole_image (texture)
		end

	texture:GAME_TEXTURE
			-- The texture to used in `Current'
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
