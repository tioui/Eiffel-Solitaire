note
	description: "Responsible of creating visual images."
	author: "Louis Marchand"
	date: "Mon, 01 Aug 2016 21:17:25 +0000"
	revision: "0.1"

class
	IMAGE_FACTORY

inherit
	ERROR_MANAGER

create
	make

feature {NONE} -- Constants

	Ressources_directory:STRING_32
			-- The directory to find the ressources (image and sound)
		once
			Result := {STRING_32}"ressources/"
		end

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

	Images_Extension:STRING_32
			-- The extension of the image files
		once
			Result := {STRING_32}".png"
		end

feature {NONE} -- Initialization

	make(a_renderer:GAME_RENDERER)
			-- Initialization of `Current' using `a_renderer' as `renderer'
		do
			default_create
			renderer := a_renderer
			create default_pixel_format
			default_pixel_format.set_argb8888
			create default_image.make(renderer, default_pixel_format, 1, 1)
			common_cards := default_image
			load_common_cards("default")
			decks := default_image
			create {COLOR_BACKGROUND}board_background.make (create {GAME_COLOR}.make_rgb_from_hexadecimal ("000000"))
			load_board("default")
		end

feature -- Access

	load_common_cards(a_name:READABLE_STRING_GENERAL)
			-- Load a pack of cards from disk using the file name `a_name' (Must reload every {CARD} objects)
		local
			l_image:IMG_IMAGE_FILE
		do
			clear_error
			create l_image.make (Cards_directory + a_name + "/cards" + Images_Extension)
			if l_image.is_openable then
				l_image.open
				if l_image.is_open then
					create common_cards.make_from_image (renderer, l_image)
				else
					set_error ("The image " + Cards_directory + a_name + "/cards" + Images_Extension + " cannot be open - " + l_image.last_sdl_error)
				end
			else
				set_error ("The image " + Cards_directory + a_name + "/cards" + Images_Extension + " cannot be open")
			end
		end

	load_board(a_name:READABLE_STRING_GENERAL)
			-- Load a pack of cards from disk using the name `a_name' (Must reload every {BOARD} objects)
		local
			l_image:IMG_IMAGE_FILE

		do
			clear_error
			create l_image.make (Boards_directory + a_name + "/decks" + Images_Extension)
			if l_image.is_openable then
				l_image.open
				if l_image.is_open then
					create decks.make_from_image (renderer, l_image)
				else
					set_error ("The image " + Boards_directory + a_name + "/decks" + Images_Extension + " cannot be open - " + l_image.last_sdl_error)
				end
			else
				set_error ("The image " + Boards_directory + a_name + "/decks" + Images_Extension + " cannot be open")
			end
			if not has_error then
				load_background(a_name)
			end

		end

	image_informations:detachable TUPLE[image:GAME_TEXTURE; sub_image_x, sub_image_y, sub_image_width, sub_image_height:INTEGER]
			-- The last image loaded, if any

	get_common_card(a_value, a_suit:INTEGER)
			-- Load the card identified with `a_value' and `a_suit' in `image_informations'
		local
			l_height, l_width:INTEGER
		do
			l_width := common_cards.width // 13
			l_height := common_cards.height // 5
			image_informations := [
									common_cards,
									(a_value - 1) * l_width,
									(a_suit - 1) * l_height,
									l_width,
									l_height
								]
		end

	get_common_card_back
			-- Load the back of a card in `image_informations'
		do
			get_common_card(3, 5)
		end

	default_image:GAME_TEXTURE
			-- A default image of 1x1 pixel

	default_pixel_format:GAME_PIXEL_FORMAT
			-- A {GAME_PIXEL_FORMAT} to used when creating {GAME_TEXTURE}

	board_background:BACKGROUND
			-- The {BACKGROUND} of the {BOARD} that has been loaded with `load_board'

	get_deck_standard
			-- Load the standard (empty) {DECK} indicator in `image_informations'
		do
			get_deck_by_index(1)
		end

	get_deck_heart
			-- Load the heart {DECK} indicator in `image_informations'
		do
			get_deck_by_index(2)
		end

	get_deck_diamond
			-- Load the diamond {DECK} indicator in `image_informations'
		do
			get_deck_by_index(3)
		end

	get_deck_club
			-- Load the club {DECK} indicator in `image_informations'
		do
			get_deck_by_index(4)
		end

	get_deck_spade
			-- Load the spade {DECK} indicator in `image_informations'
		do
			get_deck_by_index(5)
		end

	get_deck_reload
			-- Load the spade {DECK} indicator in `image_informations'
		do
			get_deck_by_index(6)
		end

feature {NONE} -- Implementation

	get_deck_by_index(a_index:INTEGER)
			-- Load the {DECK} indicator having index `a_index' in `image_informations'
		local
			l_height, l_width:INTEGER
		do
			l_width := decks.width // 6
			l_height := decks.height
			image_informations := [decks, (a_index - 1) * l_width, 0, l_width, l_height]
		end

	load_background(a_name:READABLE_STRING_GENERAL)
			-- Load the `board_background' from the file identified by `a_name'
		local
			l_preferences:PREFERENCES
			l_manager:PREFERENCE_MANAGER
			l_factory:BASIC_PREFERENCE_FACTORY
			l_value:STRING_32
		do
			create l_preferences.make_with_location (Boards_directory + a_name + "/board.xml")
			l_manager := l_preferences.new_manager ("boards")
			create l_factory
			l_value := l_factory.new_string_32_preference_value (l_manager, "background_type", {STRING_32}"").value
			if l_value ~ {STRING_32}"color" then
				load_color_background(l_preferences)
			elseif l_value.is_empty then
				set_error ("Error while reading Board informations. No Background Type found.")
			else
				set_error ("Error while reading Board informations. Background Type " + l_value + "is not valid.")
			end
		end

	load_color_background(a_preferences: PREFERENCES)
			-- Load a {COLOR_BACKGROUND} in the `board_background' using preferences `a_preferences'
		require
			Preferences_Manager_Exists: a_preferences.has_manager ("boards")
		local
			l_value:STRING_32
			l_factory:BASIC_PREFERENCE_FACTORY
		do
			if attached a_preferences.manager ("boards") as la_manager then
				create l_factory
				l_value := l_factory.new_string_32_preference_value (la_manager, "background_color", {STRING_32}"").value
				if not l_value.is_empty then
					create {COLOR_BACKGROUND}board_background.make (create {GAME_COLOR}.make_rgb_from_hexadecimal (l_value))
				else
					set_error ({STRING_32}"Cannot find the color of the board collored background.")
				end
			else
				set_error ({STRING_32}"Cannot load the color of the board collored background.")
			end
		end

	renderer:GAME_RENDERER
			-- The game window renderer

	common_cards:GAME_TEXTURE
			-- The image of every common cards

	decks:GAME_TEXTURE
			-- The image of every {DECK} indicator

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
