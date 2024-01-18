@icon("res://assets/tex/floor.png")
class_name Floor extends RigidBody2D


@export var SIZE: float = 256
@export var AMMOUNT: int = 12


func reset():
	position.x += SIZE * AMMOUNT
