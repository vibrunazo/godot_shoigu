extends Control

class_name Game

@export var bird: Bird
@export var hud: Hud
@export var wall_scene: PackedScene

static var game_ref: Game
var score: int = 0
var state: STATE = STATE.INI
enum STATE {
	INI,
	PLAY,
	GAME_OVER
}

func _init():
	Game.game_ref = self

func _ready():
	state = STATE.INI
	$AudioMusic.volume_db = -60
	music_fade_in()
	if bird:
		bird.died.connect(_on_bird_died)
	await get_tree().create_timer(3.4).timeout
	play()

func play():
	state = STATE.PLAY
	bird.play()
	$SpawnTimer.start()

func music_fade_in():
	var tween = create_tween()
	tween.tween_property($AudioMusic, "volume_db", -12, 2)

func _on_bird_died():
	print('bird dead')
	state = STATE.GAME_OVER
	$SpawnTimer.stop()
	await get_tree().create_timer(5).timeout
	reset()

func reset():
	get_tree().reload_current_scene()

func _on_spawn_timer_timeout():
	if state == STATE.GAME_OVER: return
	spawn_wall()
	$SpawnTimer.start(randf_range(1.8, 4.5))

func spawn_wall():
	if not bird: return
	var wall: Node2D = wall_scene.instantiate()
	$walls.add_child(wall)
	wall.position.x = bird.position.x + 1600
	wall.position.y += randf_range(-350, 400) + 400

func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
func add_score():
	if state != STATE.PLAY: return
	score += 1
	print('scored: %d' % score)
	if hud:
		hud.set_score(score)
		
func pause_clicked():
	get_tree().paused = !get_tree().paused
