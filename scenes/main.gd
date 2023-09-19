extends Control

class_name Game

@export var bird: Bird
@export var ui: UI
@export var wall_scene: PackedScene
@onready var hud: Hud


# saved at
# %APPDATA%\Godot\
var SAVE_PATH := "user://config.cfg"
static var game_ref: Game
var score: int = 0
var high: int = 0
# ellapsed time in seconds, updated at every spawn
var time: float = 0
var state: STATE = STATE.INI
enum STATE {
	INI,
	PLAY,
	GAME_OVER
}
var music_volume_min: = -64
var music_volume_max: = -12
var music_volume: = -12
var music_enabled: = true
var music_tween: Tween
var sfx_enabled: = true
var audio_enabled: = true
var config = ConfigFile.new()

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
	music_fade_in()
	
	await get_tree().create_timer(3.4).timeout
	play()

func play():
	state = STATE.PLAY
	bird.play()
	$SpawnTimer.start()

func music_fade_in():
	music_tween = create_tween()
	music_tween.tween_property($AudioMusic, "volume_db", music_volume, 2)

func music_fade_out():
	music_tween = create_tween()
	music_tween.tween_property($AudioMusic, "volume_db", music_volume_min, 2)

func toggle_music(value: bool):
	music_enabled = value
	toggle_bus("Music", value)

func toggle_sfx(value: bool):
	sfx_enabled = value
	toggle_bus("Sfx", value)

func toggle_audio(value: bool):
	audio_enabled = value
	toggle_bus("Master", value)

func toggle_bus(bus: String, value: bool):
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), !value)
	config.set_value("settings", bus.to_lower(), value)
	config.save(SAVE_PATH)
	Global.audio_updated.emit()

func save_game():
	# Store some values.
	config.set_value("game", "high_score", high)
	# Save it to a file (overwrite if already exists).
	config.save(SAVE_PATH)

func load_game():
	# Load data from a file.
	var err = config.load(SAVE_PATH)
	# If the file didn't load, ignore it.
	if err != OK:
		return
	high = config.get_value("game", "high_score", 0)
	Global.update_score.emit()
	toggle_audio(config.get_value("settings", "master", true))
	toggle_music(config.get_value("settings", "music", true))
	Global.game_loaded.emit()
	
	

func _on_bird_died():
	print('bird dead')
	state = STATE.GAME_OVER
	$SpawnTimer.stop()
	if score > high: high = score
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
	spawn_wall()
	var min_time = 2.0
	var max_time = 4.5
	if time > 20:
		min_time = 1.9
		max_time = 3.0
	var next_time = randf_range(min_time, max_time)
	time += next_time
	$SpawnTimer.start(next_time)

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
	Global.update_score.emit()
#	if hud:
#		hud.set_score(score)
		
func pause_clicked():
	get_tree().paused = !get_tree().paused
	if state == STATE.GAME_OVER: return
	if get_tree().paused:
		Global.show_pause.emit()
	else:
		Global.hide_pause.emit()

func _notification(what):
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
		print("focus in")
	elif what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
		print("focus out")
		pause_clicked()
