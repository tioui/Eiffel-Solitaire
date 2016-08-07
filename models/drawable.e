note
	description: "An element that can be drawn on the scene."
	author: "Louis Marchand"
	date: "Mon, 01 Aug 2016 21:17:25 +0000"
	revision: "0.1"

deferred class
	DRAWABLE

inherit
	COORDINATES
	
feature {NONE} -- Initialization

	make(a_image_factory:IMAGE_FACTORY)
			-- Initialization of `Current' using `a_image_factory' as `image_factory'
		do
			image_factory := a_image_factory
			image := image_factory.default_image
			reload_image
			must_show := True
		ensure
			Is_Image_Factory_Assign: image_factory ~ a_image_factory
		end
feature -- Access

	sub_image_x, sub_image_y:INTEGER
			-- The starting position of the part of `image' to show

	width, height:INTEGER
			-- The dimension of the part of `image' to show

	image:GAME_TEXTURE
			-- Visual representation of `Current'

	reload_image
			-- Update the `image' from the `image_factory'
		deferred
		end

	must_show:BOOLEAN
			-- `Current' must be showed

feature {NONE} -- Implementation

	image_factory:IMAGE_FACTORY
			-- The factory used to load `image'

	set_image_informations(a_information:TUPLE[image:GAME_TEXTURE; sub_image_x, sub_image_y, sub_image_width, sub_image_height:INTEGER])
			-- Assign `image', `sub_image_x', `sub_image_y', `width' and `height' using `a_information'
		do
			sub_image_x := a_information.sub_image_x
			sub_image_y := a_information.sub_image_y
			width := a_information.sub_image_width
			height := a_information.sub_image_height
			image := a_information.image
		ensure
			Image_Assign: image ~ a_information.image
			Sub_Image_X_Assign: sub_image_x ~ a_information.sub_image_x
			Sub_Image_Y_Assign: sub_image_y ~ a_information.sub_image_y
			Width_Assign: width ~ a_information.sub_image_width
			Height_Assign: height ~ a_information.sub_image_height
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
