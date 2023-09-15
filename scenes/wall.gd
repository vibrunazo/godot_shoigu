@icon("res://assets/tex/wall.png")
extends Node2D

class_name Wall

func _ready():
	await get_tree().create_timer(20).timeout
	queue_free()


func _on_area_score_body_entered(body):
	if body is Bird:
		Game.game_ref.add_score()
