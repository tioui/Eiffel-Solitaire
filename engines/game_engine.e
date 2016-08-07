note
	description: "An {ENGINE} that execute a game"
	author: "Louis Marchand"
	date: "Mon, 01 Aug 2016 21:17:25 +0000"
	revision: "0.1"

deferred class
	GAME_ENGINE

inherit
	ENGINE
		redefine
			set_events, redraw_scene, run
		end

feature -- Access

	run
			-- <Precursor>
		do
			prepare
			Precursor
		end

	set_events
			-- <Precursor>
		do
			context.window.size_change_actions.extend (agent on_resize)
			Precursor
		end

	board: BOARD
			-- The playing surface

	redraw_scene
			-- Redraw every element of the scene
		local
			l_renderer:GAME_RENDERER
			l_old_color:GAME_COLOR
		do
			l_renderer := context.window.renderer
			board.background.draw (l_renderer)
			if attached target as la_target then
				l_renderer.set_target (la_target)
				l_old_color := l_renderer.drawing_color
				l_renderer.set_drawing_color (create {GAME_COLOR}.make (255, 0, 0, 0))
				l_renderer.clear
				l_renderer.set_drawing_color (l_old_color)
			end
			draw_drawables(l_renderer)
			if attached target as la_target then
				l_renderer.set_original_target
				l_renderer.draw_sub_texture_with_scale (
											la_target, 0, 0, la_target.width, la_target.height,
											board_destination_x, board_destination_y,
											board_destination_width, board_destination_height
										)
			end
			Precursor
		end

feature {NONE} -- Implementation

	target:detachable GAME_TEXTURE
			-- The {GAME_TEXTURE} of the same size of the `board' to draw the scene

	prepare
			-- Set the initial layout of the game
		do
			prepare_board
			set_board_destination
		end

	set_board_destination
			-- Calculate the `board_destination_x', `board_destination_y',
			-- `board_destination_width' and `board_destination_height' values
		local
			l_ratio_width, l_ratio_height:REAL_64
			l_renderer:GAME_RENDERER
			l_target:GAME_TEXTURE_TARGET
		do
			l_renderer := context.window.renderer
			l_ratio_width := l_renderer.output_size.width / board.width
			l_ratio_height := l_renderer.output_size.height / board.height
			board_ratio := l_ratio_height.min (l_ratio_width)
			board_destination_height := (board.height * board_ratio).floor
			board_destination_width := (board.width * board_ratio).floor
			board_destination_x := (l_renderer.output_size.width - board_destination_width) // 2
			board_destination_y := (l_renderer.output_size.height - board_destination_height) // 2
			create l_target.make (l_renderer, context.image_factory.default_pixel_format, board.width, board.height)
			l_target.enable_alpha_blending
			target := l_target
		end

	board_ratio:REAL_64
			-- The ratio between the dimension of the `board' vs the dimension of the renderer

	board_destination_x, board_destination_y:INTEGER
			-- Coordinates of the drawing destination

	board_destination_width, board_destination_height:INTEGER
			-- Dimension of the drawing destination

	prepare_board
			-- Prepare the `board'
		deferred
		end

	draw_drawables(a_renderer:GAME_RENDERER)
			-- Draw on `a_renderer' every {DRAWABLE} of the scene
		deferred
		end

	on_resize(a_timestamp:NATURAL_32)
			-- When the {GAME_WINDOW} has been resized
		do
			set_board_destination
		end

	cursor_on(a_x, a_y, a_width, a_height:INTEGER):BOOLEAN
			-- The mouse cursor is in the area from the point (`a_x',`a_y') and of dimension `a_width'x`a_height'
		local
			l_cursor_coordinate:TUPLE[x, y:INTEGER]
		do
			l_cursor_coordinate := cursor_coordinate
			Result := is_on(
						l_cursor_coordinate.x, l_cursor_coordinate.y,
						a_x, a_y, a_width, a_height
					)
		end

	is_on(a_x, a_y, a_reference_x, a_reference_y, a_reference_width, a_reference_height:INTEGER):BOOLEAN
			-- The point (`a_x',`a_y') is in the rectangle starting at (`a_reference_x',`a_reference_y')
			-- with dimension `a_reference_width'x`a_reference_height'
		do
			Result := (
						a_x >= a_reference_x and a_x < a_reference_x + a_reference_width and
						a_y >= a_reference_y and a_y < a_reference_y + a_reference_height
					)
		end

	is_on_drawable(a_x, a_y:INTEGER; a_drawable:DRAWABLE):BOOLEAN
			-- True if the point (`a_x',`a_y') is on `a_drawable'
		do
			Result := is_on(a_x, a_y, a_drawable.x, a_drawable.y, a_drawable.width, a_drawable.height)
		end

	to_board_coordinate(a_x, a_y:INTEGER):TUPLE[x, y:INTEGER]
			-- Calculate the absolute window coordinate (`a_x',`a_y') into the `board'
		local
			l_to_x, l_to_y:INTEGER
		do
			l_to_x := ((a_x - board_destination_x) / board_ratio).rounded
			l_to_y := ((a_y - board_destination_y) / board_ratio).rounded
			Result := [l_to_x, l_to_y]
		end

	cursor_coordinate:TUPLE[x, y:INTEGER]
			-- Calculate the coordinate of the mouse cursor into the `board'
		local
			l_cursor:GAME_MOUSE_STATE
		do
			create l_cursor
			Result := to_board_coordinate(l_cursor.x, l_cursor.y)
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
