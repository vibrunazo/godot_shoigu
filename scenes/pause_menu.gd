extends Control

class_name PauseMenu


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.show_pause.connect(start)
	Global.hide_pause.connect(stop)
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start():
	$Anim.play("start")

func stop():
	$Anim.play("stop")
