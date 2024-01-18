#@icon("res://assets/tex/shoigu/image10.png")
class_name Bird extends RigidBody2D

signal died

@export var flap_power = 300
@export var flap_up_bonus = 220
@export var speed = 160

@onready var anim: AnimatedSprite2D = $Anim
@onready var audio_hit: AudioStreamPlayer2D = $AudioHit
@onready var collision: CollisionPolygon2D = $Col

var state: STATE = STATE.INI
enum STATE {
	INI,
	PLAY,
	DEAD
}
var ini_gravity: float = 1
var last_hit: int = Time.get_ticks_msec()
var flap_up: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
#	anim.animation_looped.connect(looped)
	anim.animation_finished.connect(looped)
#	anim.pause()
	linear_velocity.x = speed
	ini_gravity = gravity_scale
	gravity_scale = 0

func _process(_delta):
	if state != STATE.PLAY: return
	var d = linear_velocity.y / 15
	rot(d)
	if is_god() and global_position.y > 800:
		global_position.y = 200
		flap()

func rot(new_rot):
	anim.rotation_degrees = new_rot
	$Col.rotation_degrees = new_rot

func play():
	state = STATE.PLAY
	gravity_scale = ini_gravity

## Enables or disables god mode which mkaes the player immune to collisions
func enable_god(enabled: bool):
	#collision.disabled = enabled
	if enabled:
		collision_layer = 2
		collision_mask = 0
	else:
		collision_layer = 3
		collision_mask = 1
		
	print('bird god: %s, layer: %s, mask: %s' % [enabled, collision_layer, collision_mask])

## Toggles god mode which mkaes the player immune to collisions
func toggle_god():
	enable_god(!is_god())

## Returns whether god mode is enabled and I'm invincible
func is_god() -> bool:
	return (collision_layer < 3)
	

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
	if Time.get_ticks_msec() - last_hit > 50 and linear_velocity.length() > 10:
		var linear_volume : float = linear_velocity.length() / 300
		audio_hit.volume_db = linear_to_db(linear_volume)
		#print('bird volume set vel: %s, linear: %s, db: %s' % [linear_velocity.length(), linear_volume, audio_hit.volume_db])
		audio_hit.play()
		last_hit = Time.get_ticks_msec()
	die()

func die():
	if state != 1: return
	state = STATE.DEAD
	angular_velocity = -16
	anim.stop()
	died.emit()


func _on_collision(body):
	if body.has_meta("obstacle"):
		hit_wall()
