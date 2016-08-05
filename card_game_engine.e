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
			Precursor
		end

	on_mouse_move(a_timestamp:NATURAL_32; a_mouse_state:GAME_MOUSE_MOTION_STATE;
						a_delta_x, a_delta_y:INTEGER_32)
			-- Laundhed when the user move the mouse on the window
		do
			if is_dragging then

			end
		end

	prepare
			-- <Precursor>
		do
			Precursor
			prepare_cards
			across board.deck_slots as la_deck loop
				update_deck(la_deck.item.deck, la_deck.item.x, la_deck.item.y)
			end
		end

	prepare_cards
			-- Set the {CARD} in the multiple {DECK} of the `board'
		deferred
		end

	draw_drawables(a_renderer:GAME_RENDERER)
			-- <Precursor>
		do
			across board.deck_slots as la_deck loop
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
							if la_deck.item.deck.first.is_face_up then
								draw_drawable(a_renderer, la_deck.item.deck.first)
							else
								card_back.set_x (la_deck.item.x)
								card_back.set_y (la_deck.item.y)
								draw_drawable(a_renderer, card_back)
							end
						end
					end
				end
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

	dragging_deck:DECK[CARD]
			-- The {DECK} used to drag card on the window

	is_dragging:BOOLEAN
			-- There is presently something that is being dragged
		do
			Result := not dragging_deck.is_empty
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
