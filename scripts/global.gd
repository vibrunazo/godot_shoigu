extends Node

signal show_pause
signal hide_pause
signal show_game_over
signal update_score
signal game_loaded
signal audio_updated
signal show_credits
signal hide_credits
signal back_pressed

# saved at
# %APPDATA%\Godot\
var SAVE_PATH := "user://config.cfg"
var music_volume_min: = -64
var music_volume_max: = -12
var music_volume: = -12
var music_enabled: = true
var music_tween: Tween
var sfx_enabled: = true
var audio_enabled: = true
var config = ConfigFile.new()

var high: int = 0

func _init():
	load_game()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	# so the Global inputs can still be handled while paused
	process_mode = Node.PROCESS_MODE_ALWAYS


func _unhandled_key_input(event):
	if event.is_action_pressed("ui_toggle_fullscreen"):
		toggle_fullscreen()

func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		


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
	audio_updated.emit()

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
	update_score.emit()
	toggle_audio(config.get_value("settings", "master", true))
	toggle_music(config.get_value("settings", "music", true))
	game_loaded.emit()
	
	
