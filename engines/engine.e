note
	description: "Manage the execution"
	author: "Louis Marchand"
	date: "Mon, 01 Aug 2016 21:17:25 +0000"
	revision: "0.1"

deferred class
	ENGINE

inherit
	ERROR_MANAGER
	GAME_LIBRARY_SHARED
		undefine
			default_create
		end

feature {NONE} -- Initialization

	make(a_context:CONTEXT)
			-- Initialization of `Current' using `a_context' as `context'
		do
			default_create
			context := a_context
			quit_signal_received := False
			create {LINKED_QUEUE[ANIMATION]}animations.make
		ensure
			Is_Context_Assign: context ~ a_context
		end

feature -- Access

	set_events
			-- Set all events to make `Current' workable
		do
			game_library.quit_signal_actions.extend (agent on_quit_signal)
			game_library.iteration_actions.extend (agent on_iteration)
			context.set_events
		end

	run
			-- Execute `Current'
		do
			quit_signal_received := False
			game_library.clear_all_events
			set_events
			game_library.launch
		end

	quit
			-- Stop the game loop and quit the `run' routine
		do
			game_library.stop
		end

	quit_signal_received:BOOLEAN
			-- The user has closed the application

	redraw
			-- Redraw the window
		do
			context.window.renderer.set_drawing_color (background_color)
			context.window.renderer.clear
			redraw_scene
			context.window.renderer.present
		end

	redraw_scene
			-- Redraw every element of the scene
		deferred
		end

	add_moving_animation(a_from, a_to:COORDINATES; a_time:NATURAL)
			-- Add an {ANIMATION} taking `a_from' to `a_to' in `a_time' millisecond
		require
			Time_Positive: a_time > 0
		local
			l_animation:MOVING_ANIMATION
			l_timestamp:NATURAL
		do
			l_timestamp := game_library.time_since_create
			create l_animation.make (a_from, a_to, l_timestamp, l_timestamp + a_time)
			animations.extend (l_animation)
		end

feature {NONE} -- Implementation

	animations:QUEUE[ANIMATION]
			-- Every {ANIMATION} that have to be played before continuing running `Current'

	is_animate:BOOLEAN
			-- An {ANIMATION} is pending
		do
			Result := not animations.is_empty
		end

	animation_done(a_animation:ANIMATION)
			-- Launched when the `a_animation' has finished
		require
			Animation_Is_Done:a_animation.is_done
		do
		end

	on_iteration(a_timestamp:NATURAL_32)
			-- Launched at each game loop
		do
			if animations.readable then
				animations.item.update (a_timestamp)
				if animations.item.is_done then
					animation_done(animations.item)
					animations.remove
				end
			end
			redraw
		end

	context:CONTEXT
			-- Singleton containing game ressources.

	on_quit_signal(a_timestamp:NATURAL_32)
			-- When the user close the window
		do
			quit_signal_received := True
			quit
		end

	draw_drawable(a_renderer:GAME_RENDERER; a_drawable:DRAWABLE)
			-- Draw `a_drawable' on the `a_renderer'
		local
			l_x, l_y:INTEGER
		do
			l_x := a_drawable.x
			l_y := a_drawable.y
			if a_drawable.x < 0 then
				l_x := 0
			end
			if a_drawable.y < 0 then
				l_y := 0
			end
			if a_drawable.x + a_drawable.width > a_renderer.output_size.width then
				l_x := a_renderer.output_size.width - a_drawable.width
			end
			if a_drawable.y + a_drawable.height > a_renderer.output_size.height then
				l_y := a_renderer.output_size.height - a_drawable.height
			end
			a_renderer.draw_sub_texture (
									a_drawable.image,
									a_drawable.sub_image_x,
									a_drawable.sub_image_y,
									a_drawable.width,
									a_drawable.height,
									l_x, l_y
								)
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

	cursor_on_drawable(a_drawable:DRAWABLE):BOOLEAN
			-- True if the `cursor_coordinate' is on `a_drawable'
		local
			l_cursor:TUPLE[x, y:INTEGER]
		do
			l_cursor := cursor_coordinate
			Result := is_on_drawable(l_cursor.x, l_cursor.y, a_drawable)
		end

	cursor_coordinate:TUPLE[x, y:INTEGER]
			-- Calculate the coordinate of the mouse cursor into the `board'
		local
			l_cursor:GAME_MOUSE_STATE
		do
			create l_cursor
			Result := [l_cursor.x, l_cursor.y]
		end

	background_color:GAME_COLOR
			-- The `GAME_COLOR' to draw in the background
		once
			create Result.make_rgb (0, 0, 0)
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
