note
	description: "Factory to create {DECK} of {CARD}"
	author: "Louis Marchand"
	date: "Sat, 30 Jul 2016 20:35:07 +0000"
	revision: "0.1"

deferred class
	DECK_FACTORY

feature {NONE} -- Initialization

	make(a_image_factory:IMAGE_FACTORY)
			-- Initialization of `Current' using `a_image_factory' as `image_factory'
		do
			image_factory := a_image_factory
		ensure
			Image_Factory_Assign: image_factory ~ a_image_factory
		end

feature {NONE} -- Implementation

	image_factory:IMAGE_FACTORY
			-- The factory used to generate {DRAWABLE}.`image'

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
