## The ghost of Kyiv
class_name Gok extends Node2D

## Speed in pixels per second in the x axis
@export var speed: float = -200

func _ready():
	await get_tree().create_timer(60).timeout
	queue_free()
	

func _physics_process(delta):
	global_position.x += delta * speed
