#@icon("res://assets/tex/shoigu/image10.png")
extends RigidBody2D

class_name Bird

@export var flap_power = 300
@export var flap_up_bonus = 220
@export var speed = 160

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
#	anim.animation_looped.connect(looped)
	anim.animation_finished.connect(looped)
#	anim.pause()
	linear_velocity.x = speed
	ini_gravity = gravity_scale
	gravity_scale = 0

func _process(delta):
	if state != STATE.PLAY: return
	var d = linear_velocity.y / 15
	rot(d)

func rot(new_rot):
	anim.rotation_degrees = new_rot
	$Col.rotation_degrees = new_rot

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
	if linear_velocity.y > 0:
		linear_velocity.y = - flap_power
	else: 
		linear_velocity.y -= flap_up_bonus
	linear_velocity.x = speed
	$AudioFlap.play()
	anim.stop()
	anim.play("default", -4, true)
	flap_up = false


func looped():
	anim.pause()
	if state == STATE.DEAD: return
	flap_up = !flap_up
	if flap_up:
		anim.play("default", 3)
	else:
		anim.play("default", -3, true)

func hit_wall():
	if Time.get_ticks_msec() - last_hit > 180:
		$AudioHit.play()
		last_hit = Time.get_ticks_msec()
	die()

func die():
	if state != 1: return
	state = STATE.DEAD
	angular_velocity = -16
	anim.stop()
	died.emit()


func _on_collision(body):
	if body is Floor or body.get_parent() is Wall:
		hit_wall()
