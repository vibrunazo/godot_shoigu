#@icon("res://assets/tex/wall.png")
class_name Wall extends Node2D

@export var tel_height_min: float = 950
@export var tel_height_max: float = 1020


@onready var game: Game = Game.game_ref
@onready var cam: GameCam = GameCam.cam_ref
@onready var hit_top: RigidBody2D = $HitTop
@onready var hit_bot: RigidBody2D = $HitBot
@onready var sprite_tel: Sprite2D = %SpriteTEL

func _ready():
	update_pos()
	update_tel()

func _process(_delta):
	if not cam: return
	adjust_sprite_relative_to_camera()

func adjust_sprite_relative_to_camera():
	var p = global_position
	var c = cam.global_position
	var d = c - p
	var k1 = -0.06
	var k2 = 0.02
	var x1 = clamp(d.x * k1, -128, 128)
	var x2 = clamp(d.x * k2, -128, 128)
	%SpriteTop2.position.x = x2
	%SpriteBottom2.position.x = x2
	hit_bot.position.x = x1
	hit_top.position.x = x1
	#sprite_tel.position.x = x1 * 0.5

## Updates the Wall y position
func update_pos():
	var ymin = -250
	var ymax = 250
	var new_y = randf_range(ymin, ymax) + 400
	global_position.y = new_y

## Updates the TEL y position and reparent it to the tel layer
func update_tel():
	if not sprite_tel: return
	var height: float = randf_range(tel_height_min, tel_height_max)
	sprite_tel.global_position.y = height
	var tel_layer: Node2D = get_tree().get_first_node_in_group("tel")
	sprite_tel.reparent(tel_layer)
	var k: float = (height - tel_height_min) / (tel_height_max - tel_height_min)
	var m: float = clampf(0.8 + k * 0.4, 0.8, 1)
	var w: float = 1.3 - k * 1.6
	sprite_tel.modulate = Color(m,m,m)
	(sprite_tel.material as ShaderMaterial).set_shader_parameter("weight", w)
	#print('wall tel height: %s, k: %s, m: %s' % [height, k, m])
	# 950 ~ 1020
	
func _on_area_score_body_entered(body):
	if body is Bird:
		game.add_score()


func _on_hit_body_entered(body):
	if body is Bird:
		body.die()
		
## Called by the gamecam when this wall hits the end
func end():
	sprite_tel.queue_free()
	queue_free()
	
