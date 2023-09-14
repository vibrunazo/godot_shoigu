extends RigidBody2D

@export var flap_power = 500
@export var speed = 200

var flap_up: bool = true
@onready var anim: AnimatedSprite2D = $Anim


# Called when the node enters the scene tree for the first time.
func _ready():
	anim.animation_looped.connect(looped)
	linear_velocity.x = speed
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		flap()
	if event.is_action_pressed("ui_accept"):
		flap()
		


func flap():
	linear_velocity.y = -flap_power
	linear_velocity.x = speed


func looped():
	anim.stop()
	flap_up = !flap_up
	if flap_up:
		anim.play()
	else:
		anim.play("default", -4, true)
