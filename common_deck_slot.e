note
	description: "A place on a {BOARD} where you can put a {DECK} of {COMMON_CARD}"
	author: "Louis Marchand"
	date: "Mon, 01 Aug 2016 21:17:25 +0000"
	revision: "0.1"

class
	COMMON_DECK_SLOT

inherit
	DECK_SLOT
		redefine
			reload_image, unset_all
		end

create
	make_not_showed,
	make_standard,
	make_heart,
	make_diamond,
	make_club,
	make_spade,
	make_reload

feature {NONE} -- Initialization

	make_heart(a_image_factory:IMAGE_FACTORY)
			-- Initialization of `Current' using `a_image_factory' as `image_factory'
			-- `Current' will show a heart {DECK} indicator
		do
			is_heart := True
			make(a_image_factory)
		ensure
			Is_Heart: is_heart
		end

	make_diamond(a_image_factory:IMAGE_FACTORY)
			-- Initialization of `Current' using `a_image_factory' as `image_factory'
			-- `Current' will show a diamond {DECK} indicator
		do
			is_diamond := True
			make(a_image_factory)
		ensure
			Is_Diamond: is_diamond
		end

	make_club(a_image_factory:IMAGE_FACTORY)
			-- Initialization of `Current' using `a_image_factory' as `image_factory'
			-- `Current' will show a club {DECK} indicator
		do
			is_club := True
			make(a_image_factory)
		ensure
			Is_Club: is_club
		end

	make_spade(a_image_factory:IMAGE_FACTORY)
			-- Initialization of `Current' using `a_image_factory' as `image_factory'
			-- `Current' will show a spade {DECK} indicator
		do
			is_spade := True
			make(a_image_factory)
		ensure
			Is_Spade: is_spade
		end

feature -- Access

	is_heart:BOOLEAN
			-- `Current' have a heart {DECK} indicator

	set_heart
			-- Set `is_heart'
		do
			unset_all
			is_heart := True
			reload_image
		end

	is_diamond:BOOLEAN
			-- `Current' have a diamond {DECK} indicator

	set_diamond
			-- Set `is_diamond'
		do
			unset_all
			is_diamond := True
			reload_image
		end

	is_club:BOOLEAN
			-- `Current' have a club {DECK} indicator

	set_club
			-- Set `is_club'
		do
			unset_all
			is_club := True
			reload_image
		end

	is_spade:BOOLEAN
			-- `Current' have a spade {DECK} indicator

	set_spade
			-- Set `is_spade'
		do
			unset_all
			is_spade := True
			reload_image
		end

	reload_image
			-- <Precursor>
		local
			l_must_change:BOOLEAN
		do
			l_must_change := False
			if is_standard then
				image_factory.get_deck_standard
				l_must_change := True
			elseif is_heart then
				image_factory.get_deck_heart
				l_must_change := True
			elseif is_diamond then
				image_factory.get_deck_diamond
				l_must_change := True
			elseif is_club then
				image_factory.get_deck_club
				l_must_change := True
			elseif is_spade then
				image_factory.get_deck_spade
				l_must_change := True
			elseif is_reload then
				image_factory.get_deck_reload
				l_must_change := True
			end
			if l_must_change then
				if attached image_factory.image_informations as la_info then
					set_image_informations(la_info)
				end
			end
		end

feature {NONE} -- Implementation

	unset_all
			-- Put to False every {DECK} indicator `is_...'
		do
			Precursor
			is_heart := False
			is_diamond := False
			is_club := False
			is_spade := False
		end

invariant
	At_Least_One: is_not_showed or is_standard or is_heart or is_diamond or is_club or is_spade or is_reload
	Only_Not_Showed: is_not_showed implies (not is_standard and not is_heart and not is_diamond and not is_club and not is_spade and not is_reload)
	Only_Standard: is_standard implies (not is_not_showed and not is_heart and not is_diamond and not is_club and not is_spade and not is_reload)
	Only_Heart: is_heart implies (not is_not_showed and not is_standard and not is_diamond and not is_club and not is_spade and not is_reload)
	Only_Diamond: is_diamond implies (not is_not_showed and not is_standard and not is_heart and not is_club and not is_spade and not is_reload)
	Only_Club: is_club implies (not is_not_showed and not is_standard and not is_heart and not is_diamond and not is_spade and not is_reload)
	Only_Spade: is_spade implies (not is_not_showed and not is_standard and not is_heart and not is_diamond and not is_club and not is_reload)
	Only_Reload: is_reload implies (not is_not_showed and not is_standard and not is_heart and not is_diamond and not is_club and not is_spade)

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
