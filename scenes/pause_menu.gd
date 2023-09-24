extends Control

class_name PauseMenu


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.show_pause.connect(start)
	Global.hide_pause.connect(stop)
	visible = false

func start():
	$Anim.play("start")

func stop():
	$Anim.play("stop")
