note
	description: "A playing surface"
	author: "Louis Marchand"
	date: "Mon, 01 Aug 2016 21:17:25 +0000"
	revision: "0.1"

class
	BOARD

create
	make

feature {NONE} -- Initialization

	make(a_factory:IMAGE_FACTORY)
			-- Initialization of `Current' using `a_factory' as `image_factory'
		do
			image_factory := a_factory
			background := image_factory.board_background
		end
feature -- Access

	background:BACKGROUND
			-- Theback desing of `Current'

	width:INTEGER assign set_width
			-- The vertical dimension of the playing area

	set_width(a_width:INTEGER)
			-- Assign `a_width' to `width'
		do
			width := a_width
		ensure
			Is_Assign: width ~ a_width
		end

	height:INTEGER assign set_height
			-- The horizontal dimension of the playing area

	set_height(a_height:INTEGER)
			-- Assign `a_height' to `height'
		do
			height := a_height
		ensure
			Is_Assign: height ~ a_height
		end

feature {NONE} -- Implementation

	image_factory:IMAGE_FACTORY
			-- Factory used to generate images

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
