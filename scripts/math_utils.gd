## Math utility static functions
class_name Math extends Node

## Calculate where 2 objects of constant velocity A and B will meet
static func calc_meetup(pos_a: float, vel_a: float, pos_b: float, vel_b: float) -> float:
	# Relative velocity (velocity of B with respect to A)
	var rel_vel := vel_b - vel_a
	# Relative position (position of B with respect to A)
	var rel_pos := pos_b - pos_a
	# Time when they will meet
	var time_to_meet := absf(rel_pos) / absf(rel_vel)
	# Position where they will meet
	var meetup_pos = pos_a + vel_a * time_to_meet

	return meetup_pos

## Calculates the initial position object B needs to start at to meet up A at given meetup_pos
static func calc_pos_to_meet_at(pos_a: float, vel_a: float, vel_b: float, meetup_pos: float) -> float:
	# Calculate the time it takes for object A to reach the meetup position
	var time_to_meet = (meetup_pos - pos_a) / vel_a
	# Calculate how far object B will travel in this time
	var travel_distance_B = vel_b * time_to_meet
	# Calculate the initial position of object B
	var pos_b = meetup_pos - travel_distance_B
	
	return pos_b

## Returns the point where a given Path2D crosses the given x coordinate.
## Returns Vector2.INF if no crossing is found
static func get_crossing_point(path: Path2D, x: float) -> Vector2:
	var points = path.curve.get_baked_points()
	for i in range(points.size() - 1):
		var point1 = points[i]
		var point2 = points[i + 1]
		if (point1.x - x) * (point2.x - x) <= 0:  # The line between point1 and point2 crosses x
			# Interpolate the y-coordinate
			var t = abs(x - point1.x) / abs(point2.x - point1.x)
			var y = point1.y + t * (point2.y - point1.y)
			return Vector2(x, y)
	return Vector2.INF  # No crossing point found
