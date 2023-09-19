extends CheckButton

class_name MusicButton

@onready var game: Game = Game.game_ref


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	Global.game_loaded.connect(update)
	Global.audio_updated.connect(update)


func update():
	button_pressed = game.music_enabled and game.audio_enabled
	disabled = !game.audio_enabled

func _on_pressed():
	game.toggle_music(button_pressed)