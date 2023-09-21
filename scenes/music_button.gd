extends CheckButton

class_name MusicButton


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.audio_updated.connect(update)
	update()

func update():
	button_pressed = Global.music_enabled and Global.audio_enabled
	disabled = !Global.audio_enabled

func _on_pressed():
	Global.toggle_music(button_pressed)
