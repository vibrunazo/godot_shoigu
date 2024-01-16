## The class for the flappy bird game
class_name Game extends Control

@export var bird: Bird
@export var ui: UI
@export var wall_scene: PackedScene
@onready var hud: Hud
@onready var spawn_timer: Timer = $SpawnTimer
@onready var cam: GameCam = $GameCam


static var game_ref: Game
## Player score
var score: int = 0
var state: STATE = STATE.INI
enum STATE {
	INI,
	PLAY,
	GAME_OVER
}
var music_tween: Tween
## Global x position of last spawned wall
var last_spawn_x: float
## Global x position of next wall to spawn
var next_spawn_x: float

func _init():
	Game.game_ref = self

func _ready():
	state = STATE.INI
	load_game()
	if bird:
		bird.died.connect(_on_bird_died)
	if ui:
		hud = ui.hud
	$AudioMusic.volume_db = -60
	Global.back_pressed.connect(_on_back)
	music_fade_in()
	
	await get_tree().create_timer(3.4).timeout
	play()

func play():
	state = STATE.PLAY
	bird.play()
	last_spawn_x = cam.global_position.x
	next_spawn_x = last_spawn_x + 500
	spawn_timer.start()
	

func load_game():
	Global.load_game()

func save_game():
	Global.save_game()

func music_fade_in():
	music_tween = create_tween()
	music_tween.tween_property($AudioMusic, "volume_db", Global.music_volume, 2)

func music_fade_out():
	music_tween = create_tween()
	music_tween.tween_property($AudioMusic, "volume_db", Global.music_volume_min, 2)

func _on_bird_died():
	print('bird dead')
	state = STATE.GAME_OVER
	spawn_timer.stop()
	if score > Global.high: Global.high = score
	Global.update_score.emit()
	save_game()
	await get_tree().create_timer(3).timeout
	on_game_over()

func on_game_over():
	music_fade_out()
	Global.show_game_over.emit()

func reset():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_spawn_timer_timeout():
	if state == STATE.GAME_OVER: return
	if cam.global_position.x >= next_spawn_x:
		spawn_wall()
		var next_min := 330.0
		var next_max := 600.0
		var next := randf_range(next_min, next_max)
		last_spawn_x = cam.global_position.x
		next_spawn_x = last_spawn_x + next
		print('game spawned next: %s' % [next])

func spawn_wall():
	if not bird: return
	var wall: Wall = wall_scene.instantiate() as Wall
	wall.position.x = bird.position.x + 1600
	$walls.add_child(wall)
	

func add_score():
	if state != STATE.PLAY: return
	score += 1
	print('scored: %d' % score)
	Global.update_score.emit()
		
func pause_clicked():
	%AudioClick.play()
	get_tree().paused = !get_tree().paused
	if state == STATE.GAME_OVER: return
	if get_tree().paused:
		Global.show_pause.emit()
	else:
		Global.hide_pause.emit()

func _on_back():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/opening.tscn")

func _notification(what):
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
		print("focus in")
	elif what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
		print("focus out")
		if not get_tree().paused:
			pause_clicked()


func _on_audio_music_finished():
	print('main audiomusic finished')
