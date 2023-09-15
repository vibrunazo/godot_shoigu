extends Control

class_name Game

@export var bird: Bird
@export var hud: Hud
@export var wall_scene: PackedScene

static var game_ref: Game
var score: int = 0

func _init():
	Game.game_ref = self

func _ready():
	print('game ini')
	await get_tree().create_timer(5).timeout
	$SpawnTimer.start()

func _on_spawn_timer_timeout():
	spawn_wall()
	$SpawnTimer.start(randf_range(1.8, 4.5))

func spawn_wall():
	if not bird: return
	var wall: Node2D = wall_scene.instantiate()
	$walls.add_child(wall)
	wall.position.x = bird.position.x + 1600
	wall.position.y += randf_range(-350, 400) + 400

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_toggle_fullscreen"):
		toggle_fullscreen()

func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
func add_score():
	score += 1
	print('scored: %d' % score)
	if hud:
		hud.set_score(score)
		
