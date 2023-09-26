#@icon("res://assets/tex/wall.png")
extends Node2D

class_name Wall

@onready var game: Game = Game.game_ref
@onready var cam: GameCam = GameCam.cam_ref

#func _ready():
#	await get_tree().create_timer(20).timeout
#	queue_free()

func _process(delta):
	if not cam: return
	adjust_sprite_relative_to_camera()

func adjust_sprite_relative_to_camera():
	var p = global_position
	var c = cam.global_position
	var d = c - p
	var k = 0.08
	var x = clamp(d.x * k, -128, 128)
	%SpriteTop2.position.x = x
	%SpriteBottom2.position.x = x

func _on_area_score_body_entered(body):
	if body is Bird:
		game.add_score()


func _on_hit_body_entered(body):
	if body is Bird:
		body.die()
