note
	description: "A place on a {BOARD} where you can put a {DECK} of {CARD}"
	author: "Louis Marchand"
	date: "Mon, 01 Aug 2016 21:17:25 +0000"
	revision: "0.1"

class
	DECK_SLOT

inherit
	DRAWABLE
		export
			{DECK_SLOT} image_factory
		redefine
			make
		end

create
	make_not_showed,
	make_standard,
	make_reload,
	make_from_other

feature {NONE} -- Initialization

	make_from_other(a_other:DECK_SLOT)
			-- Initialization of `Current' copying the data of `a_other'
		do
			deck := a_other.deck
			can_receive_drag := a_other.can_receive_drag
			height := a_other.height
			identifier := a_other.identifier
			is_clickable := a_other.is_clickable
			is_count_visible := a_other.is_count_visible
			is_draggable := a_other.is_draggable
			is_expanded_vertically := a_other.is_expanded_vertically
			is_reload := a_other.is_reload
			is_standard := a_other.is_standard
			must_show := a_other.must_show
			sub_image_x := a_other.sub_image_x
			sub_image_y := a_other.sub_image_y
			image_factory := a_other.image_factory
			image := a_other.image
			width := a_other.width
			x := a_other.x
			y := a_other.y
		end

	make(a_image_factory:IMAGE_FACTORY)
			-- <Precursor>
		do
			create deck.make
			Precursor(a_image_factory)
		end

	make_not_showed(a_image_factory:IMAGE_FACTORY)
			-- Initialization of `Current' using `a_image_factory' as `image_factory'
			-- `Current' will not show any {DECK} indicator
		do
			make(a_image_factory)
			must_show := False
		ensure
			Is_Not_Showed: is_not_showed
		end

	make_standard(a_image_factory:IMAGE_FACTORY)
			-- Initialization of `Current' using `a_image_factory' as `image_factory'
			-- `Current' will show a standard (empty) {DECK} indicator
		do
			is_standard := True
			make(a_image_factory)
		ensure
			Is_Not_Standard: is_standard
		end

	make_reload(a_image_factory:IMAGE_FACTORY)
			-- Initialization of `Current' using `a_image_factory' as `image_factory'
			-- `Current' will show a reload {DECK} indicator
		do
			is_reload := True
			make(a_image_factory)
		ensure
			Is_Reload: is_reload
		end

feature -- Access

	identifier:INTEGER assign set_identifier
			-- May be used to identify `Current'

	set_identifier(a_identifier:INTEGER)
			-- Assign `a_identifier' to `identifier'
		do
			identifier := a_identifier
		ensure
			Is_Assign: identifier ~ a_identifier
		end

	is_clickable:BOOLEAN assign set_is_clickable
			-- Launch an action when the user clicked on `Current'

	set_is_clickable(a_value:BOOLEAN)
			-- Assign `a_value' to `is_clickable'
		do
			is_clickable := a_value
		ensure
			Is_Assign: is_clickable ~ a_value
		end

	is_double_clickable:BOOLEAN assign set_is_double_clickable
			-- Launch an action when the user double clicked on `Current'

	set_is_double_clickable(a_value:BOOLEAN)
			-- Assign `a_value' to `is_double_clickable'
		do
			is_double_clickable := a_value
		ensure
			Is_Assign: is_double_clickable ~ a_value
		end

	is_expanded_vertically:BOOLEAN assign set_is_expanded_vertically
			-- When True, every {CARD} of the `deck' will be visible (by moving expanding them vertically).
			-- When False, only the on on the top

	set_is_expanded_vertically(a_value:BOOLEAN)
			-- Assign `a_value' to `is_expanded_vertically'
		do
			is_expanded_vertically := a_value
		ensure
			Is_Assign: is_expanded_vertically ~ a_value
		end

	is_expanded_horizontally:BOOLEAN assign set_is_expanded_horizontally
			-- When True, every {CARD} of the `deck' will be visible (by moving expanding them horizontally).
			-- When False, only the on on the top

	set_is_expanded_horizontally(a_value:BOOLEAN)
			-- Assign `a_value' to `is_expanded_horizontally'
		do
			is_expanded_horizontally := a_value
		ensure
			Is_Assign: is_expanded_horizontally ~ a_value
		end

	expanded_count:INTEGER assign set_expanded_count
			-- If `is_expanded_vertically' or `is_expanded_horizontally' is set,
			-- indicate the number of card to actually expand. 0 for every {CARD}.

	set_expanded_count(a_count:INTEGER)
			-- Assign `a_count' to `expanded_count'
		require
			Positive: a_count >= 0
		do
			expanded_count := a_count
		ensure
			Is_Assign: expanded_count ~ a_count
		end

	is_count_visible:BOOLEAN assign set_is_count_visible
			-- True if every the user have to be able to have an
			-- indication of how many card is in the `deck'

	set_is_count_visible(a_value:BOOLEAN)
			-- Assin `a_value' to `is_count_visible'
		do
			is_count_visible := a_value
		ensure
			Is_Assign: is_count_visible ~ a_value
		end

	is_draggable:BOOLEAN assign set_is_draggable
			-- When True, any {CARD} on the `deck' may be dragged (with those on top of it)
			-- If `is_expanded_vertically' is false, only the top {CARD} of the `deck' can be dragged

	set_is_draggable(a_value:BOOLEAN)
			-- Assign `a_value' to `is_draggable'
		do
			is_draggable := a_value
		ensure
			Is_Assign: is_draggable ~ a_value
		end

	can_receive_drag:BOOLEAN assign set_can_receive_drag
			-- When True, `Curent' may received a {CARD}s drag

	set_can_receive_drag(a_value:BOOLEAN)
			-- Assign `a_value' to `can_receive_drag'
		do
			can_receive_drag := a_value
		ensure
			Is_Assign: can_receive_drag ~ a_value
		end

	is_not_showed:BOOLEAN
			-- `Current' does not have any {DECK} indicator to print on the board
		do
			Result := not must_show
		end

	is_standard:BOOLEAN
			-- `Current' have a standard {DECK} indicator (empty)

	set_standard
			-- Set `is_standard'
		do
			unset_all
			is_standard := True
			reload_image
		end

	is_reload:BOOLEAN
			-- `Current' have a reload {DECK} indicator

	set_reload
			-- Set `is_reload'
		do
			unset_all
			is_reload := True
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

	deck:DECK[CARD] assign set_deck
			-- The {DECK} of {CARD} that `Current' contain.

	set_deck(a_deck: like deck)
			-- Assign `a_deck' to `deck'
		do
			deck := a_deck
		ensure
			Is_Assign: deck ~ a_deck
		end

feature {NONE} -- Implementation

	unset_all
			-- Put to False every {DECK} indicator `is_...'
		do
			must_show := False
			is_standard := False
			is_reload := False
		end

invariant
	Only_Not_Showed: is_not_showed implies (not is_standard and not is_reload)
	Only_Standard: is_standard implies (not is_not_showed and not is_reload)
	Only_Reload: is_reload implies (not is_not_showed and not is_standard)
	Draggable_Not_Clickable: not (is_draggable and is_clickable)

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
