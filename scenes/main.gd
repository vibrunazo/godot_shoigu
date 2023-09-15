extends Control

class_name Game

@export var bird: Bird
@export var wall_scene: PackedScene

func _ready():
	print('game ini')
	await get_tree().create_timer(10).timeout
	$SpawnTimer.start()


func _on_spawn_timer_timeout():
	spawn_wall()
	$SpawnTimer.start(randf_range(1.5, 5))
	

func spawn_wall():
	var wall: Node2D = wall_scene.instantiate()
	$walls.add_child(wall)
	wall.position.x = bird.position.x + 800
	wall.position.y += randf_range(-400, 400) + 400


func _on_start_timer_timeout():
	pass # Replace with function body.
