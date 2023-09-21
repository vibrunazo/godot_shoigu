extends CheckButton

class_name AudioButton

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.audio_updated.connect(update)
	update()

func update():
	button_pressed = Global.audio_enabled

func _on_pressed():
	Global.toggle_audio(button_pressed)
