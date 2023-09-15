@icon("res://assets/tex/shoigu/image10.png")
extends RigidBody2D

class_name Bird

@export var flap_power = 400
@export var speed = 200

var flap_up: bool = true
@onready var anim: AnimatedSprite2D = $Anim
var state: int = 0
var ini_gravity: float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.animation_looped.connect(looped)
	linear_velocity.x = speed
	ini_gravity = gravity_scale
	gravity_scale = 0
	await get_tree().create_timer(2).timeout
	state = 1
	gravity_scale = ini_gravity
	

# Called every frame. 'delta' is the elapsed time since the previous frame.4
func _process(delta):
	pass

func _unhandled_input(event):
	if state != 1: return
	if event is InputEventMouseButton and event.is_pressed():
		flap()
	if event.is_action_pressed("ui_accept"):
		flap()
		


func flap():
	linear_velocity.y = -flap_power
	linear_velocity.x = speed


func looped():
	anim.stop()
	if state == 2: return
	flap_up = !flap_up
	if flap_up:
		anim.play()
	else:
		anim.play("default", -4, true)

func die():
	if state != 1: return
	state = 2
	angular_velocity = -8


func _on_collision(body):
	print('collide with %s' % body)
	if body is Floor or body.get_parent() is Wall:
		die()
