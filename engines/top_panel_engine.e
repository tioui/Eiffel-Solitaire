note
	description: "A menu show at the top of a game."
	author: "Louis Marchand"
	date: "Mon, 14 Nov 2016 02:57:39 +0000"
	revision: "0.1"

class
	TOP_PANEL_ENGINE

inherit
	MENU_ITEM_ENGINE
		rename
			make as make_menu
		redefine
			initialize_menu_image, set_events, redraw_scene
		end
	DIMENSIONS
		export
			{NONE} set_height
		undefine
			default_create
		redefine
			set_width, set_height
		end

create
	make

feature {NONE} -- Initialization

	make(a_context:CONTEXT; a_game_name:READABLE_STRING_GENERAL; a_width:INTEGER)
			-- Initialization of `Current' with vertical dimension of `a_width'
			-- using `a_context' as `context' and `a_game_name' as `title'
		do
			is_horizontal := True
			height := 80
			width := a_width
			game_name := a_game_name
			make_menu(a_context)
			add_spacer
			add_items ("Menu", agent to_menu)
		end

	initialize_title
			-- Initialize the `title' attribute
		do
			title := game_name
		end

feature -- Access

	prepare
			-- Initialize `Current'
		do
			is_menu_requested := False
		end

	set_events
			-- <Precursor>
		do
			context.window.mouse_button_released_actions.extend (agent on_mouse_release)
		end

	redraw_scene
			-- <Precursor>
		local
			l_renderer:GAME_RENDERER
		do
			l_renderer := context.window.renderer
			context.window.renderer.draw_texture (menu_image, x, y)
			if is_horizontal then
				redraw_content_horizontal(l_renderer, content_menu_start, menu_image.width - 30)
			else
				redraw_content_vertical(l_renderer, content_menu_start, menu_image.height - 30)
			end
		end

	game_name:READABLE_STRING_GENERAL
			-- Used to set `title'

	set_width(a_width:INTEGER)
			-- <Precursor>
		do
			Precursor {DIMENSIONS}(a_width)
			initialize_menu_image
		end

	set_height(a_height:INTEGER)
			-- <Precursor>
		do
			Precursor {DIMENSIONS}(a_height)
			initialize_menu_image
		end

	is_menu_requested:BOOLEAN
			-- The user ask to open the {MAIN_MENU}

	clear_is_menu_requested
			-- Put `is_menu_requested' to False
		do
			is_menu_requested := False
		ensure
			Is_Set: not is_menu_requested
		end

feature {NONE} -- Initialization

	to_menu
			-- Action used when the user ask to open the {MAIN_MENU}
		do
			is_menu_requested := True
			quit
		ensure
			Is_Set: is_menu_requested
		end

	initialize_menu_image
			-- Create the `menu_image'
		local
			l_renderer:GAME_RENDERER
			l_format:GAME_PIXEL_FORMAT
			l_texture:GAME_TEXTURE_TARGET
			l_old_target:GAME_RENDER_TARGET
		do
			l_renderer := context.window.renderer
			create l_format.default_create
			l_format.set_abgr8888
			create l_texture.make (l_renderer, l_format, width, height)
			l_old_target := l_renderer.target
			l_renderer.set_target (l_texture)
			draw_inside_menu_image
			put_border_menu_image
			put_title_menu_image
			l_renderer.set_target (l_old_target)
			menu_image := l_texture
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
