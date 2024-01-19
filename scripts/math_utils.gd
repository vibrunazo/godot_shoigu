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
