note
	description: "An {ENGINE} to execute {CARD} games"
	author: "Louis Marchand"
	date: "Mon, 01 Aug 2016 21:17:25 +0000"
	revision: "0.1"

deferred class
	CARD_GAME_ENGINE

inherit
	GAME_ENGINE
		redefine
			board, prepare, set_events
		end

feature -- Access

	deck_factory:DECK_FACTORY
			-- Factory used to create {DECK}

	board:CARD_BOARD
			-- <Precursor>

feature {NONE} -- Implementation

	set_events
			-- <Precursor>
		do
			context.window.mouse_motion_actions.extend (agent on_mouse_move)
			context.window.mouse_button_pressed_actions.extend (agent on_mouse_down)
			context.window.mouse_button_released_actions.extend (agent on_mouse_up)
			Precursor
		end

	on_mouse_move(a_timestamp:NATURAL_32; a_mouse_state:GAME_MOUSE_MOTION_STATE;
						a_delta_x, a_delta_y:INTEGER_32)
			-- Launched when the user move the mouse on the window
		do
			if is_dragging and not a_mouse_state.is_left_button_pressed then
				cancel_drop
			end
		end

	on_mouse_up(a_timestamp:NATURAL_32; a_mouse_state:GAME_MOUSE_BUTTON_RELEASED_STATE;
																	a_nb_clicks:NATURAL_8)
			-- Launched when the user press a mouse button
		local
			l_deck_slots:LIST[DECK_SLOT]
			l_mouse_coordinates:TUPLE[x, y:INTEGER]
			l_deck_slot:detachable DECK_SLOT
			l_drawable:DRAWABLE
		do
			if a_mouse_state.is_left_button_released and is_dragging then
				l_mouse_coordinates := to_board_coordinate(a_mouse_state.x, a_mouse_state.y)
				l_deck_slots := board.deck_slots
				from
					l_deck_slots.start
				until
					l_deck_slots.exhausted or
					attached l_deck_slot
				loop
					if l_deck_slots.item.deck.is_empty then
						l_drawable := l_deck_slots.item
					else
						l_drawable := l_deck_slots.item.deck.last
					end
					if is_on_drawable (l_mouse_coordinates.x, l_mouse_coordinates.y, l_drawable) then
						l_deck_slot := l_deck_slots.item
					end
					l_deck_slots.forth
				end
				if
					attached l_deck_slot as la_slot and
					attached dragging_deck as la_dragging_deck and
					attached origin_draggin_deck_slot as la_dragging_slot
				then
					if can_drop(slot_converter (la_slot), la_dragging_deck) then
						la_slot.deck.finish
						la_slot.deck.merge_right (la_dragging_deck)
						after_drop(slot_converter (la_dragging_slot), slot_converter (la_slot), la_dragging_deck)
						dragging_deck := Void
						origin_draggin_deck_slot := Void
						update_deck_slot(la_slot)
					else
						cancel_drop
					end
				else
					cancel_drop
				end
			end
		end

	after_drop(a_from_slot:DECK_SLOT; a_destination_slot:DECK_SLOT; a_dragging_deck:DECK[CARD])
			-- Launched after a drag and drop from `a_from_slot' to `a_destination_slot' has terminate correctly
			-- using `a_dragging_deck'
		deferred
		end

	cancel_drop
			-- Stop the current drag and replace {CARDS} in the `dragging_deck' where they belong
		do
			if
				attached dragging_deck as la_deck and
				attached origin_draggin_deck_slot as la_slot
			then
				la_slot.deck.finish
				la_slot.deck.merge_right (la_deck)
				dragging_deck := Void
				origin_draggin_deck_slot := Void
			end
		end

	can_drop(a_deck_slot:DECK_SLOT; a_dragging_deck:DECK[CARD]):BOOLEAN
			-- True if `a_deck_slot' can receive the {CARD}s of `a_dragging_deck'
		require
			a_dragging_deck.count > 0
		deferred
		end


	on_mouse_down(a_timestamp:NATURAL_32; a_mouse_state:GAME_MOUSE_BUTTON_PRESSED_STATE;
																	a_nb_clicks:NATURAL_8)
			-- Launched when the user press a mouse button
		local
			l_deck_slots:LIST[DECK_SLOT]
			l_mouse_coordinates:TUPLE[x, y:INTEGER]
			is_done:BOOLEAN
		do
			if a_mouse_state.is_left_button_pressed and not is_dragging then
				l_mouse_coordinates := to_board_coordinate(a_mouse_state.x, a_mouse_state.y)
				l_deck_slots := board.deck_slots
				from
					l_deck_slots.start
					is_done := False
				until
					l_deck_slots.exhausted or
					is_done
				loop
					if l_deck_slots.item.is_draggable then
						on_mouse_down_dragging(l_deck_slots.item, l_mouse_coordinates)
						is_done := is_dragging
					elseif l_deck_slots.item.is_clickable then
						on_mouse_down_clicked(l_deck_slots.item, l_mouse_coordinates)
					end
					l_deck_slots.forth
				end
			end
		end


	on_mouse_down_clicked(a_deck_slot:DECK_SLOT; a_mouse_coordinates:TUPLE[x, y:INTEGER])
			-- Manage the clicked version of `on_mouse_down'
		require
			Is_Clicakble: a_deck_slot.is_clickable
		local
			l_deck:DECK[CARD]
		do
			l_deck := a_deck_slot.deck
			if l_deck.count > 0 then
				if is_on_drawable (a_mouse_coordinates.x, a_mouse_coordinates.y, l_deck.last) then
					manage_click(slot_converter (a_deck_slot))
					update_deck_slot (a_deck_slot)
				end
			else
				if is_on_drawable (a_mouse_coordinates.x, a_mouse_coordinates.y, a_deck_slot) then
					manage_click(slot_converter (a_deck_slot))
					update_deck_slot (a_deck_slot)
				end
			end
		end

	on_mouse_down_dragging(a_deck_slot:DECK_SLOT; a_mouse_coordinates:TUPLE[x, y:INTEGER])
			-- Manage the dragging version of `on_mouse_down'
		require
			Is_Draggable: a_deck_slot.is_draggable
		local
			l_deck:DECK[CARD]
			is_done:BOOLEAN
		do
			l_deck := a_deck_slot.deck
			if l_deck.count > 0 then
				l_deck.finish
				if a_deck_slot.is_expanded then
					from
						l_deck.finish
					until
						l_deck.exhausted or
						is_done
					loop
						if is_on_drawable (a_mouse_coordinates.x, a_mouse_coordinates.y, l_deck.item) then
							start_dragging(a_deck_slot, l_deck.index, l_deck.duplicate (l_deck.count), a_mouse_coordinates)
							is_done := True
						end
						l_deck.back
					end
				else
					if is_on_drawable (a_mouse_coordinates.x, a_mouse_coordinates.y, l_deck.item) then
						start_dragging(a_deck_slot, l_deck.index, l_deck.duplicate (1), a_mouse_coordinates)
					end
				end
			end
		end

	manage_click(a_slot:DECK_SLOT)
			-- Launched when a user clicked on `a_slot'
		deferred
		end

	start_dragging(a_slot:DECK_SLOT; a_index:INTEGER; a_deck:DECK[CARD]; a_mouse_coordinates:TUPLE[x, y:INTEGER])
			-- Start a drag using `a_slot' as original {DECK_SLOT}, `a_index' as the index of the {CARD} in the
			-- `a_slot'.`deck', the dragging {DECK} is `a_deck' and the user clicked at `a_mouse_coordinate'
		do
			if can_drag (slot_converter (a_slot), a_index, deck_converter(a_deck)) then
				drag_x := a_mouse_coordinates.x - a_slot.deck.at (a_index).x
				drag_y := a_mouse_coordinates.y - a_slot.deck.at (a_index).y
				dragging_deck := deck_converter(a_deck)
				origin_draggin_deck_slot := a_slot
				from
					a_slot.deck.go_i_th(a_index)
				until
					a_slot.deck.exhausted
				loop
					a_slot.deck.remove
				end
			end
		end

	deck_converter(a_deck:DECK[CARD]):DECK[CARD]
			-- Convert `a_deck' to the correct type of {CARD} for `Current'
		do
			Result := a_deck
		end

	slot_converter(a_slot:DECK_SLOT):DECK_SLOT
			-- Convert `a_slot' to the correct type of {CARD} for `Current'
		do
			Result := a_slot
		end

	can_drag(a_deck_slot:DECK_SLOT; a_index:INTEGER; a_deck:DECK[CARD]):BOOLEAN
			-- Is a drag possible from the {CARD} `a_index' of the `a_deck_slot'
			-- resulting with the {DECK} `a_deck'
		deferred
		end

	prepare
			-- <Precursor>
		do
			Precursor
			prepare_cards
			across board.deck_slots as la_deck loop
				update_deck_slot(la_deck.item)
			end
		end

	prepare_cards
			-- Set the {CARD} in the multiple {DECK} of the `board'
		deferred
		end

	draw_drawables(a_renderer:GAME_RENDERER)
			-- <Precursor>
		local
			l_cursor:TUPLE[x,y:INTEGER]
			l_deck_slot:DECK_SLOT
		do
			across board.deck_slots as la_deck loop
				l_deck_slot := la_deck.item
				if la_deck.item.deck.is_empty then
					draw_drawable(a_renderer, la_deck.item)
				else
					if la_deck.item.is_expanded then
						update_expanded_deck(la_deck.item.deck, la_deck.item.x, la_deck.item.y)
						draw_deck(a_renderer, la_deck.item.deck)
					else
						if la_deck.item.is_count_visible then
							update_count_visible_deck(la_deck.item.deck, la_deck.item.x, la_deck.item.y)
							draw_deck(a_renderer, la_deck.item.deck)
						else
							if la_deck.item.deck.last.is_face_up then
								draw_drawable(a_renderer, la_deck.item.deck.last)
							else
								card_back.set_x (la_deck.item.x)
								card_back.set_y (la_deck.item.y)
								draw_drawable(a_renderer, card_back)
							end
						end
					end
				end
			end
			if attached dragging_deck as la_deck then
				l_cursor :=cursor_coordinate
				update_expanded_deck(la_deck, l_cursor.x - drag_x, l_cursor.y - drag_y)
				draw_deck(a_renderer, la_deck)
			end
		end

	update_deck_slot(a_deck_slot:DECK_SLOT)
			-- Update the `x' and `y' of every {CARD}s in `a_deck_slot'
		do
			if a_deck_slot.is_expanded then
				update_expanded_deck(a_deck_slot.deck, a_deck_slot.x, a_deck_slot.y)
			elseif a_deck_slot.is_count_visible then
				update_count_visible_deck(a_deck_slot.deck, a_deck_slot.x, a_deck_slot.y)
			else
				update_deck(a_deck_slot.deck, a_deck_slot.x, a_deck_slot.y)
			end
		end

	update_deck(a_deck:DECK[CARD]; a_x, a_y:INTEGER)
			-- Set the `x' and `y' to `a_x' and `a_y' of every {CARD} of `a_deck'
		do
			across a_deck as la_deck loop
				la_deck.item.set_x (a_x)
				la_deck.item.set_y (a_y)
			end
		end

	update_expanded_deck(a_deck:DECK[CARD]; a_x, a_y:INTEGER)
			-- Set the `x' and `y' of every {CARD} of `a_deck'
			-- knowing that `a_deck' is expanded and is at position (`a_x',`a_y')
		local
			l_draw_y, l_draw_x:INTEGER
			l_face_up_count, l_face_down_count, l_indentation:INTEGER
		do
			l_face_up_count := 0
			l_face_down_count := 0
			across a_deck as la_deck loop
				if la_deck.item.is_face_up then
					l_face_up_count := l_face_up_count + 1
				else
					l_face_down_count := l_face_down_count + 1
				end
			end
			if l_face_up_count > 0 then
				l_indentation := (((board.height - a_y) - (l_face_down_count * 15) - card_back.height) // l_face_up_count).min(60)
			else
				l_indentation := 60
			end
			l_draw_y := a_y
			l_draw_x := a_x
			across a_deck as la_deck loop
				la_deck.item.set_x(l_draw_x)
				if la_deck.item.is_face_up then
					if
						not is_dragging and l_indentation < 60 and not la_deck.is_last and
						cursor_on(l_draw_x, l_draw_y, la_deck.item.width, l_indentation)
					then
						la_deck.item.set_y (l_draw_y - (60 - l_indentation))
					else
						la_deck.item.set_y (l_draw_y)
					end
					l_draw_y := l_draw_y + l_indentation
				else
					la_deck.item.set_y (l_draw_y)
					l_draw_y := l_draw_y + 15
				end
			end
		end

	update_count_visible_deck(a_deck:DECK[CARD]; a_x, a_y:INTEGER)
			-- Set the `x' and `y' of every {CARD} of `a_deck'
			-- knowing that `a_deck' must have count visible and is at position (`a_x',`a_y')
		local
			l_draw_y, l_draw_x:INTEGER
		do
			l_draw_y := a_y
			l_draw_x := a_x
			across a_deck as la_deck loop
				la_deck.item.set_x (l_draw_x)
				la_deck.item.set_y (l_draw_y)
				l_draw_y := l_draw_y + 1
				l_draw_x := l_draw_x + 1
			end
		end

	draw_deck(a_renderer:GAME_RENDERER; a_deck:DECK[CARD])
			-- Draw every {CARD} of `a_deck' on `a_renderer'
		do

			across a_deck as la_deck loop
				if la_deck.item.is_face_up then
					draw_drawable(a_renderer, la_deck.item)
				else
					card_back.set_x (la_deck.item.x)
					card_back.set_y (la_deck.item.y)
					draw_drawable(a_renderer, card_back)
				end
			end
		end

	card_back:CARD_BACK
			-- {DRAWABLE} representing the back of a {CARD}

	dragging_deck:detachable DECK[CARD]
			-- The {DECK} used to drag card on the window

	origin_draggin_deck_slot:detachable DECK_SLOT
			-- The {DECK_SLOT} that the `dragging_deck' origin from

	drag_x, drag_y:INTEGER
			-- The distance between the cursor and the upper left point of the dragged {DECK}

	is_dragging:BOOLEAN
			-- There is presently something that is being dragged
		do
			Result := attached dragging_deck
		end

invariant
	Dragging_deck_valid: attached dragging_deck as la_deck implies not la_deck.is_empty
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
