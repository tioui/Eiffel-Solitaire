note
	description: "An {ENGINE} to show {MENU_ITEM} list"
	author: "Louis Marchand"
	date: "Mon, 14 Nov 2016 02:57:39 +0000"
	revision: "0.1"

deferred class
	MENU_ITEM_ENGINE

inherit
	ENGINE
		redefine
			make, redraw_scene, set_events
		end
	COORDINATES
		undefine
			default_create
		end


feature {NONE} -- Initialization

	make(a_context:CONTEXT)
			-- Initialization of `Current' using `a_context' as `context'
		do
			Precursor(a_context)
			initialize_title
			initialize_menu_image
			create {LINKED_LIST[TUPLE[text:READABLE_STRING_GENERAL; drawable:MENU_ITEM]]}internal_items.make
			menu_selections := [
								create {MENU_SELECTION}.make_left (context.image_factory),
								create {MENU_SELECTION}.make_center (context.image_factory),
								create {MENU_SELECTION}.make_right (context.image_factory)
							]
		end

	initialize_title
			-- Initialize the `title' attribute
		deferred
		end

feature -- Access

	set_events
			-- <Precursor>
		do
			Precursor
			context.window.size_change_actions.extend (agent on_resized)
			context.window.mouse_button_released_actions.extend (agent on_mouse_release)
		end

	redraw_scene
			-- <Precursor>
		local
			l_renderer:GAME_RENDERER
		do
			l_renderer := context.window.renderer
			x := (l_renderer.output_size.width // 2) - (menu_image.width // 2)
			y := (l_renderer.output_size.height // 2) - (menu_image.height // 2)
			context.window.renderer.draw_texture (menu_image, x, y)
			if is_horizontal then
				redraw_content_horizontal(l_renderer, content_menu_start, menu_image.width - 30)
			else
				redraw_content_vertical(l_renderer, content_menu_start, menu_image.height - 30)
			end
		end

	title:READABLE_STRING_GENERAL
			-- A text identifier of `Current'

	items:LIST[READABLE_STRING_GENERAL]
			-- Every menu items to show on `Current'
		do
			create {ARRAYED_LIST[READABLE_STRING_GENERAL]}Result.make (internal_items.count)
			across internal_items as la_item loop
				Result.extend (la_item.item.text)
			end
		end

	set_title(a_title:READABLE_STRING_GENERAL)
			-- Assign `a_title' to `title'
		do
			title := a_title
			initialize_menu_image
		ensure
			Is_Assign: title ~ a_title
		end

feature {NONE} -- Implementation

	is_horizontal:BOOLEAN
			-- `Current' must be shown horizontally

	on_mouse_release(a_timestamp:NATURAL_32; a_mouse_state:GAME_MOUSE_BUTTON_RELEASED_STATE; a_nb_clicks:NATURAL_8)
			-- When the user release the mouse
		do
			across internal_items as la_item loop
				if
						attached {MENU_ITEM_DRAWABLE}la_item.item.drawable as la_drawable
					and then (
							la_drawable.is_selectable
						and
							cursor_on_drawable (la_drawable)
					)
				then
					la_drawable.action.call
				end
			end
		end

	content_menu_start:INTEGER
			-- The top for vertical menu and left for horizontal menu of the menu content

	reverse_queue(a_queue:LINKED_QUEUE[ANY])
			-- Reverse the elements in `a_queue'
		local
			l_list:ARRAYED_LIST[ANY]
		do
			create l_list.make (a_queue.count)
			from
			until a_queue.is_empty
			loop
				l_list.extend (a_queue.item)
				a_queue.remove
			end
			across -l_list.new_cursor as la_list loop
				a_queue.extend (la_list.item)
			end
		end

	redraw_content_horizontal(a_renderer:GAME_RENDERER; a_content_left, a_content_right:INTEGER)
			-- Redraw the menu content on the `a_renderer' from the horizontal position `a_content_left' to `a_content_right'
		local
			l_index, l_indentation, l_demi_height, l_y:INTEGER
			l_queue: LINKED_QUEUE[like internal_items.item]
		do
			l_demi_height := y + (menu_image.height // 2)
			l_index := a_content_left + x
			l_indentation := 1
			from
				create l_queue.make
				l_queue.append (internal_items)
			until
				l_queue.is_empty
			loop
				from
				until
					l_queue.is_empty or
					attached {MENU_ITEM_SPACER}l_queue.item.drawable
				loop
					if attached {MENU_ITEM_DRAWABLE}l_queue.item.drawable as la_drawable then
						l_y := l_demi_height - (la_drawable.height // 2)
						la_drawable.set_coordinates(l_index, l_y)
						if la_drawable.is_selectable and cursor_on_drawable (la_drawable) then
							draw_menu_selection(la_drawable)
						end
						draw_drawable (a_renderer, la_drawable)
						l_index := l_index + (l_indentation * 20) + (l_indentation * la_drawable.width)
					end
					l_queue.remove
				end
				if l_indentation = -1 then
					l_queue.wipe_out
				end
				if not l_queue.is_empty and then attached {MENU_ITEM_SPACER}l_queue.item.drawable  then
					l_queue.remove
					l_indentation := -1
					if not l_queue.is_empty then
						reverse_queue(l_queue)
						if attached {MENU_ITEM_DRAWABLE}l_queue.item.drawable as la_drawable then
							l_index := x + a_content_right - la_drawable.width
						end
					end

				end
			end
		end

	redraw_content_vertical(a_renderer:GAME_RENDERER; a_content_top, a_content_bottom:INTEGER)
			-- Redraw the menu content on the `a_renderer' from the horizontal position `a_content_top' to `a_content_bottom'
		local
			l_index, l_indentation, l_demi_width, l_x:INTEGER
			l_queue: LINKED_QUEUE[like internal_items.item]
		do
			l_demi_width := x + (menu_image.width // 2)
			l_index := a_content_top + y
			l_indentation := 1
			from
				create l_queue.make
				l_queue.append (internal_items)
			until
				l_queue.is_empty
			loop
				from
				until
					l_queue.is_empty or
					attached {MENU_ITEM_SPACER}l_queue.item.drawable
				loop
					if attached {MENU_ITEM_DRAWABLE}l_queue.item.drawable as la_drawable then
						l_x := l_demi_width - (la_drawable.width // 2)
						la_drawable.set_coordinates(l_x, l_index)
						if la_drawable.is_selectable and cursor_on_drawable (la_drawable) then
							draw_menu_selection(la_drawable)
						end
						draw_drawable (a_renderer, la_drawable)
						l_index := l_index + (l_indentation * 20) + (l_indentation * la_drawable.height)
					end
					l_queue.remove
				end
				if l_indentation = -1 then
					l_queue.wipe_out
				end
				if not l_queue.is_empty and then attached {MENU_ITEM_SPACER}l_queue.item.drawable  then
					l_queue.remove
					l_indentation := -1
					if not l_queue.is_empty then
						reverse_queue(l_queue)
						if attached {MENU_ITEM_DRAWABLE}l_queue.item.drawable as la_drawable then
							l_index := y + a_content_bottom - la_drawable.height
						end
					end

				end
			end
		end

	draw_menu_selection(a_drawable:DRAWABLE)
			-- Draw the `menu_selections' indicators over `a_drawable'
		do
			menu_selections.left.x := a_drawable.x - menu_selections.left.width
			menu_selections.left.y := a_drawable.y + (a_drawable.height // 2) - (menu_selections.left.height // 2)
			draw_drawable (context.window.renderer, menu_selections.left)
			menu_selections.center.y := a_drawable.y + (a_drawable.height // 2) - (menu_selections.left.height // 2)
			draw_loop_horizontal(menu_selections.center, a_drawable.x, a_drawable.x + a_drawable.width)
			menu_selections.right.x := a_drawable.x + a_drawable.width
			menu_selections.right.y := a_drawable.y + (a_drawable.height // 2) - (menu_selections.right.height // 2)
			draw_drawable (context.window.renderer, menu_selections.right)
		end

	internal_items:LIST[TUPLE[text:READABLE_STRING_GENERAL; drawable:MENU_ITEM]]
			-- Internal representation of `items'

	add_items(a_text:READABLE_STRING_GENERAL; a_action:PROCEDURE)
			-- Add the menu item `a_text' in `internal_items'
		local
			l_item:MENU_ITEM
		do
			context.image_factory.get_menu_text (a_text, 20)
			if attached context.image_factory.menu_text as la_text then
				create {MENU_ITEM_DRAWABLE}l_item.make (context.image_factory, la_text, a_action)
				internal_items.extend ([a_text, l_item])
			end
		end

	add_spacer
			-- Add a spacer in `items'
		do
			internal_items.extend (["", create {MENU_ITEM_SPACER}])
		end

	menu_selections:TUPLE[left, center, right:MENU_SELECTION]
			-- The left, center and right part of the selection indicator

	menu_image:GAME_TEXTURE
			-- The visual of `Current'

	on_resized(a_timestamp:NATURAL)
			-- When the Window is resized
		do
			initialize_menu_image
		end

	initialize_menu_image
			-- Create the `menu_image'
		local
			l_renderer:GAME_RENDERER
			l_format:GAME_PIXEL_FORMAT
			l_texture:GAME_TEXTURE_TARGET
			l_old_target:GAME_RENDER_TARGET
			l_width, l_height :INTEGER
		do
			l_renderer := context.window.renderer
			create l_format.default_create
			l_format.set_abgr8888
			l_width := l_renderer.output_size.width // 3
			l_height := (l_width.to_double * 1.6180339887).rounded
			if l_height > l_renderer.output_size.height then
				l_height := l_renderer.output_size.height
			end
			create l_texture.make (l_renderer, l_format, l_width, l_height)
			l_old_target := l_renderer.target
			l_renderer.set_target (l_texture)
			draw_inside_menu_image
			put_border_menu_image
			put_title_menu_image
			l_renderer.set_target (l_old_target)
			menu_image := l_texture
		end

	draw_inside_menu_image
			-- Draw the inside of the `menu_image'
		local
			l_renderer:GAME_RENDERER
			l_x, l_y:INTEGER
			l_ressource:MENU_PANEL
		do
			l_renderer := context.window.renderer
			create l_ressource.make (context.image_factory)
			from
				l_x := 0
			until
				l_x > l_renderer.output_size.width
			loop
				from
					l_y := 0
				until
					l_y > l_renderer.output_size.height
				loop
					l_ressource.set_coordinates (l_x, l_y)
					draw_drawable (l_renderer, l_ressource)
					l_y := l_y + l_ressource.height
				end
				l_x := l_x + l_ressource.width
			end
		end

	put_border_menu_image
			-- Draw 3d borders on the `menu_image'
		local
			l_width, l_height, l_loop_last, l_loop_start, l_loop_end, l_loop_next:INTEGER
			l_drawable:MENU_PANEL_CORNER
			l_renderer:GAME_RENDERER
		do
			l_renderer := context.window.renderer
			l_width := l_renderer.output_size.width
			l_height := l_renderer.output_size.height
			create l_drawable.make_top_left (context.image_factory)
			l_drawable.set_coordinates (0, 0)
			draw_drawable (l_renderer, l_drawable)
			l_loop_last := l_drawable.height
			l_loop_start := l_drawable.width
			create l_drawable.make_top_right (context.image_factory)
			l_drawable.set_coordinates (l_width - l_drawable.width, 0)
			draw_drawable (l_renderer, l_drawable)
			l_loop_end := l_drawable.x
			l_loop_next := l_drawable.height
			create l_drawable.make_top (context.image_factory)
			l_drawable.y := 0
			draw_loop_horizontal(l_drawable, l_loop_start, l_loop_end)
			l_loop_start := l_loop_next
			create l_drawable.make_bottom_right (context.image_factory)
			l_drawable.set_coordinates (l_width - l_drawable.width, l_height - l_drawable.height)
			draw_drawable (l_renderer, l_drawable)
			l_loop_end := l_height - l_drawable.height
			l_loop_next := l_width - l_drawable.width
			create l_drawable.make_right (context.image_factory)
			l_drawable.x := l_width - l_drawable.width
			draw_loop_vertical(l_drawable, l_loop_start, l_loop_end)
			l_loop_end := l_loop_next
			create l_drawable.make_bottom_left (context.image_factory)
			l_drawable.set_coordinates (0, l_height - l_drawable.height)
			draw_drawable (l_renderer, l_drawable)
			l_loop_start := l_drawable.width
			l_loop_next := l_height - l_drawable.height
			create l_drawable.make_bottom (context.image_factory)
			l_drawable.y := l_height - l_drawable.height
			draw_loop_horizontal(l_drawable, l_loop_start, l_loop_end)
			create l_drawable.make_left (context.image_factory)
			l_drawable.x := 0
			draw_loop_vertical(l_drawable, l_loop_last, l_loop_next)
		end

	draw_loop_horizontal(a_drawable:DIMENSION_MUTABLE_DRAWABLE; a_from_x, a_to_x:INTEGER)
			-- Draw an horizontal series of `a_drawable' on the `menu_image' starting at `a_from_x' and finishing at `a_to_x'.
		local
			l_renderer:GAME_RENDERER
			l_old_width:INTEGER
		do
			l_renderer := context.window.renderer
			from
				a_drawable.x := a_from_x
			until
				a_drawable.x > a_to_x - a_drawable.width
			loop
				draw_drawable (l_renderer, a_drawable)
				a_drawable.x := a_drawable.x + a_drawable.width
			end
			if a_drawable.x < a_to_x then
				l_old_width := a_drawable.width
				a_drawable.set_width(a_to_x - a_drawable.x)
				draw_drawable (l_renderer, a_drawable)
				a_drawable.set_width(l_old_width)
			end
		end

	draw_loop_vertical(a_drawable:DIMENSION_MUTABLE_DRAWABLE; a_from_y, a_to_y:INTEGER)
			-- Draw a vertical series of `a_drawable' on the `menu_image' starting at `a_from_y' and finishing at `a_to_y'.
		local
			l_renderer:GAME_RENDERER
			l_old_height:INTEGER
		do
			l_renderer := context.window.renderer
			from
				a_drawable.y := a_from_y
			until
				a_drawable.y > a_to_y - a_drawable.height
			loop
				draw_drawable (l_renderer, a_drawable)
				a_drawable.y := a_drawable.y + a_drawable.height
			end
			if a_drawable.y < a_to_y then
				l_old_height := a_drawable.height
				a_drawable.set_height(a_to_y - a_drawable.y)
				draw_drawable (l_renderer, a_drawable)
				a_drawable.set_height(l_old_height)
			end
		end

	put_title_menu_image
			-- Put the `title' on `menu_image'
		do
			if is_horizontal then
				put_title_menu_image_horizontal
			else
				put_title_menu_image_vertical
			end
		end

	put_title_menu_image_vertical
			-- Put the `title' on a vertical `menu_image'
		local
			l_x:INTEGER
		do
			context.image_factory.get_menu_text (title, 30)
			content_menu_start := 30
			if attached context.image_factory.menu_text as la_title_image then
				if la_title_image.width + 30 * 2 < context.window.renderer.output_size.width then
					l_x := (context.window.renderer.output_size.width // 2) - (la_title_image.width // 2)
					context.window.renderer.draw_texture (la_title_image, l_x, 30)
					context.window.renderer.draw_filled_rectangle (
													30, 40 + la_title_image.height,
													context.window.renderer.output_size.width - 60, 3
												)
					content_menu_start := 70 + la_title_image.height
				end
			end
		end

	put_title_menu_image_horizontal
			-- Put the `title' on an horizontal `menu_image'
		local
			l_y:INTEGER
		do
			context.image_factory.get_menu_text (title, 30)
			content_menu_start := 30
			if attached context.image_factory.menu_text as la_title_image then
				l_y := (context.window.renderer.output_size.height // 2) - (la_title_image.height // 2)
				context.window.renderer.draw_texture (la_title_image, 20, l_y)
				context.window.renderer.draw_filled_rectangle (
												40 + la_title_image.width, 10,
												3, context.window.renderer.output_size.height - 20
											)
				content_menu_start := 70 + la_title_image.width
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
