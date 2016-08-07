note
	description: "Summary description for {MOVING_ANIMATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MOVING_ANIMATION

inherit
	ANIMATION

create
	make

feature {NONE} -- Initialization

	make(a_moving, a_to:COORDINATES; a_from_timestamp, a_to_timestamp:NATURAL)
			-- Initialization of `Current' using `a_moving' as `moving' and `from_coordinates',
			-- `a_to' as `to_coordinates', `a_from_timestamp' as `timestamp' and `from_timestamp'
			-- and `a_to_timestamp' as `to_timestamp'
		require
			From_Lower_Than_To: a_from_timestamp < a_to_timestamp
		do
			create from_coordinates.set_coordinates(a_moving.x, a_moving.y)
			moving := a_moving
			to_coordinates := a_to
			from_timestamp := a_from_timestamp
			timestamp := a_from_timestamp
			to_timestamp := a_to_timestamp
		ensure
			Is_Moving_Assign: moving.x ~ a_moving.x and moving.y ~ a_moving.y
			Is_From_Assign: from_coordinates.x ~ a_moving.x and from_coordinates.y ~ a_moving.y
			Is_To_Coordinates_Assign: to_coordinates.x ~ a_to.x and to_coordinates.y ~ a_to.y
			Is_From_Timestamp_Assign: from_timestamp ~ a_from_timestamp
			Is_Timestamp_Assign: timestamp ~ a_from_timestamp
			Is_To_Timestamp_Assign: to_timestamp ~ a_to_timestamp
		end

feature -- Access

	from_coordinates:COORDINATES
			-- The starting point of `Current'

	moving:COORDINATES
			-- The object to move

	to_coordinates:COORDINATES
			-- The destination point of `Current'

	update(a_timestamp:NATURAL)
			-- <Precursor>
		local
			l_ratio:REAL_64
		do
			timestamp := a_timestamp
			if timestamp >= to_timestamp then
				moving.set_coordinates (to_coordinates.x, to_coordinates.y)
			else
				l_ratio := (to_timestamp - from_timestamp) / (timestamp - from_timestamp)
				moving.set_x (((to_coordinates.x - from_coordinates.x) / l_ratio).rounded + from_coordinates.x)
				moving.set_y (((to_coordinates.y - from_coordinates.y) / l_ratio).rounded + from_coordinates.y)
			end
		end


end
