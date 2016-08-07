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
		end

	run
			-- Execute `Current'
		do
			quit_signal_received := False
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

	redraw_scene
			-- Redraw every element of the scene
		do
			context.window.renderer.present
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
			redraw_scene
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
		do
			a_renderer.draw_sub_texture (
									a_drawable.image,
									a_drawable.sub_image_x,
									a_drawable.sub_image_y,
									a_drawable.width,
									a_drawable.height,
									a_drawable.x,
									a_drawable.y
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
