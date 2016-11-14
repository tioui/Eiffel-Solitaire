note
	description: "A {BACKGROUND} showing an `image'."
	author: "Louis Marchand"
	date: "Mon, 14 Nov 2016 02:57:39 +0000"
	revision: "0.1"

class
	IMAGE_BACKGROUND

inherit
	BACKGROUND

create
	make

feature {NONE} -- Initialization

	make(a_image:GAME_TEXTURE)
			-- Initialization of `Current' using `a_image' as `image'
		do
			image := a_image
		end

feature -- Access

	image:GAME_TEXTURE
			-- The image to show on the scene

	draw(a_renderer:GAME_RENDERER)
			-- <Precursor>
		local
			l_ratio, l_ratio_width, l_ratio_height:REAL_64
			l_width, l_height:INTEGER
		do
			l_ratio_width := a_renderer.output_size.width / image.width
			l_ratio_height := a_renderer.output_size.height / image.height
			l_ratio := l_ratio_height.min (l_ratio_width)
			l_width := (l_ratio * image.width).floor
			l_height := (l_ratio * image.height).floor
			a_renderer.draw_sub_texture (
									image, 0, 0, l_width, l_height,
									(a_renderer.output_size.width // 2) - (l_width // 2),
									(a_renderer.output_size.height // 2) - (l_height // 2)
								)
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
