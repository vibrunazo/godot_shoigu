extends RigidBody2D

class_name Floor

@export var SIZE: float = 256
@export var AMMOUNT: int = 9


func reset():
	position.x += SIZE * AMMOUNT
