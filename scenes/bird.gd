extends Node2D

var flap_up: bool = true
@onready var anim: AnimatedSprite2D = $Anim


# Called when the node enters the scene tree for the first time.
func _ready():
	anim.animation_looped.connect(looped)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func looped():
	print('looped')
	anim.stop()
	flap_up = !flap_up
	if flap_up:
		anim.play()
	else:
		anim.play("default", -4, true)
