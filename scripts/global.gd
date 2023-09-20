extends Node

signal show_pause
signal hide_pause
signal show_game_over
signal update_score
signal game_loaded
signal audio_updated


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _unhandled_key_input(event):
	if event.is_action_pressed("ui_toggle_fullscreen"):
		toggle_fullscreen()

func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
