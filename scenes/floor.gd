@icon("res://assets/tex/floor.png")
extends RigidBody2D

class_name Floor

@export var SIZE: float = 256
@export var AMMOUNT: int = 12


func reset():
	position.x += SIZE * AMMOUNT
