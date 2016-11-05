note
	description: "Singleton to access every unique ressources of the system"
	author: "Louis Marchand"
	date: "Mon, 01 Aug 2016 21:17:25 +0000"
	revision: "0.1"

class
	CONTEXT

inherit
	GAME_LIBRARY_SHARED
		redefine
			default_create
		end
	ERROR_MANAGER
		redefine
			default_create
		end

feature {NONE} -- Implementation

	default_create
			-- Initialization of `Current'
		do
			Precursor {ERROR_MANAGER}
			base_directory := game_library.base_path
			game_library.get_preference_path({STRING_32}"Tioui", {STRING_32}"Eiffel_Solitaire")
			preference_directory := game_library.preference_path
			create preferences.make_with_location (preference_directory.extended ("preferences.xml").name)
			initialise_window
			create image_factory.make (window.renderer, base_directory.name)
			if image_factory.has_error then
				set_error (image_factory.error_message)
			end
		end

	initialise_window
			-- Initalise the `window' using data in the preference file in `preference_directory'
		local
			l_window_builder:GAME_WINDOW_RENDERED_BUILDER
			l_factory:BASIC_PREFERENCE_FACTORY
			l_manager:PREFERENCE_MANAGER
			l_mode:GAME_DISPLAY_MODE
		do
			create l_window_builder
			l_window_builder.enable_resizable
			if attached preferences.manager ("window") as la_manager then
				l_manager := la_manager
			else
				l_manager := preferences.new_manager ("window")
			end
			create l_factory
			if l_factory.new_boolean_preference_value (l_manager, "fullscreen", False).value then
				l_mode := (create {GAME_DISPLAY}.make (0)).current_mode
				l_window_builder.enable_fullscreen
				l_window_builder.set_width (l_mode.width)
				l_window_builder.set_height (l_mode.height)
			else
				l_window_builder.set_width (l_factory.new_integer_preference_value (l_manager, "width", 800).value)
				l_window_builder.set_height (l_factory.new_integer_preference_value (l_manager, "height", 600).value)
			end
			preferences.save_preferences
			window := l_window_builder.generate_window
			if window.has_error then
				set_error ({STRING_32}"Cannot generate a Window.")
			end
		end

feature -- Access

	set_events
			-- Set all events to make `Current' workable
		do
			window.resize_actions.extend (agent on_window_size_change)
		end

	toggle_fullscreen
			-- Switch from windowed to fullscreen (or vice versa)
		local
			l_factory:BASIC_PREFERENCE_FACTORY
			l_manager:PREFERENCE_MANAGER
			l_mode:GAME_DISPLAY_MODE
			l_preference:BOOLEAN_PREFERENCE
		do
			if attached preferences.manager ("window") as la_manager then
				l_manager := la_manager
			else
				l_manager := preferences.new_manager ("window")
			end
			create l_factory
			l_preference := l_factory.new_boolean_preference_value (l_manager, "fullscreen", False)
			if window.is_fullscreen then
				l_preference.set_value (False)
				window.set_windowed
				window.set_width (l_factory.new_integer_preference_value (l_manager, "width", 800).value)
				window.set_height (l_factory.new_integer_preference_value (l_manager, "height", 600).value)
			else
				l_mode := (create {GAME_DISPLAY}.make (0)).current_mode
				l_preference.set_value (True)
				window.set_width (l_mode.width)
				window.set_height (l_mode.height)
				window.set_fullscreen
			end
			preferences.set_preference ("fullscreen", l_preference)
			preferences.save_preferences
		end

	window:GAME_WINDOW_RENDERED
			-- The OS window to draw the scene

	image_factory:IMAGE_FACTORY
			-- The factory used to generate {DRAWABLE}.`image'

	preference_directory:PATH
			-- The directory to used to store preferences

	preferences:PREFERENCES
			-- User preferences

	base_directory:PATH
			-- The directory containing the executable

feature {NONE} -- Implementation

	on_window_size_change(a_timestamp:NATURAL_32; a_width, a_height:INTEGER_32)
			-- When the size of the window has changed
		local
			l_factory:BASIC_PREFERENCE_FACTORY
			l_manager:PREFERENCE_MANAGER
			l_preference:INTEGER_PREFERENCE
		do
			if attached preferences.manager ("window") as la_manager then
				l_manager := la_manager
			else
				l_manager := preferences.new_manager ("window")
			end
			create l_factory
			l_preference := l_factory.new_integer_preference_value (l_manager, "width", a_width)
			l_preference.set_value (a_width)
			preferences.set_preference ("width", l_preference)
			l_preference := l_factory.new_integer_preference_value (l_manager, "height", a_height)
			l_preference.set_value (a_height)
			preferences.set_preference ("height", l_preference)
			preferences.save_preferences
		end

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
