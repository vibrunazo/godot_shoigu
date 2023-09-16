@icon("res://assets/tex/shoigu/image10.png")
extends RigidBody2D

class_name Bird

@export var flap_power = 350
@export var flap_up_bonus = 220
@export var speed = 200

var flap_up: bool = true
@onready var anim: AnimatedSprite2D = $Anim
var state: STATE = STATE.INI
enum STATE {
	INI,
	PLAY,
	DEAD
}
var ini_gravity: float = 1
var last_hit: int = Time.get_ticks_msec()
signal died

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.animation_looped.connect(looped)
	linear_velocity.x = speed
	ini_gravity = gravity_scale
	gravity_scale = 0

func play():
	state = STATE.PLAY
	gravity_scale = ini_gravity
	

func _unhandled_input(event):
	if state != 1: return
#	if event is InputEventMouseButton and event.is_pressed():
#		flap()
	if event.is_action_pressed("flap"):
		flap()
		


func flap():
	var flap_y = flap_power
	if linear_velocity.y < 0:
		flap_y += flap_up_bonus
	linear_velocity.y = - flap_y
	linear_velocity.x = speed
	$AudioFlap.play()


func looped():
	anim.stop()
	if state == STATE.DEAD: return
	flap_up = !flap_up
	if flap_up:
		anim.play()
	else:
		anim.play("default", -4, true)
		

func hit_wall():
	if Time.get_ticks_msec() - last_hit > 180:
		$AudioHit.play()
		last_hit = Time.get_ticks_msec()
	die()

func die():
	if state != 1: return
	state = STATE.DEAD
	angular_velocity = -16
	died.emit()


func _on_collision(body):
	if body is Floor or body.get_parent() is Wall:
		hit_wall()
