@icon("res://assets/tex/wall.png")
extends Node2D

class_name Wall

func _ready():
	await get_tree().create_timer(20).timeout
	queue_free()
