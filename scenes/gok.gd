## The ghost of Kyiv
class_name Gok extends Node2D

## Speed in pixels per second in the x axis
@export var speed: float = -200

@onready var game: Game = Game.game_ref
@onready var collision_shape: CollisionShape2D = $Hit/CollisionShape2D
@onready var score_collision_shape: CollisionShape2D = $AreaScore/CollisionShape2D

func _ready():
	await get_tree().create_timer(60).timeout
	queue_free()
	

func _physics_process(delta):
	global_position.x += delta * speed
	
func set_collision_enabled(enabled: bool):
	if not collision_shape:
		collision_shape = $Hit/CollisionShape2D
	collision_shape.disabled = !enabled
	if not score_collision_shape:
		score_collision_shape = $AreaScore/CollisionShape2D
	score_collision_shape.disabled = !enabled

func _on_area_score_body_entered(body):
	if body is Bird:
		game.add_score()
