extends CheckButton

class_name AudioButton

@onready var game: Game = Game.game_ref


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.game_loaded.connect(update)

func update():
	button_pressed = game.audio_enabled

func _on_pressed():
	game.toggle_audio(button_pressed)
