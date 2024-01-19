## The path the Player needs to take to win. Enemies will avoid it.
class_name WinPath extends Node2D

@onready var line: Line2D = $Line2D
@onready var path: Path2D = $Path2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var path_points = path.curve.get_baked_points()
	line.points = path_points
	line.hide()

## Returns the y coordinate of the point closest to given x coordinate
func get_y_from_x(xpos: float) -> float:
	#path.curve.get_closest_point()
	return Math.get_crossing_point(path, xpos).y

## Toggles whether the line is visible
func toggle_visible():
	line.visible = !line.visible
