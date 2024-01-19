## The class for the flappy bird game
class_name Game extends Control

@export var bird: Bird
@export var ui: UI
@export var wall_scene: PackedScene
@export var gok_scene: PackedScene
@onready var hud: Hud
@onready var spawn_timer: Timer = $SpawnTimer
@onready var cam: GameCam = $GameCam
@onready var audio_music: AudioStreamPlayer = $AudioMusic


static var game_ref: Game
## Player score
var score: int = 0
var state: STATE = STATE.INI
enum STATE {
	INI,
	PLAY,
	GAME_OVER
}
var music_tween: Tween
## Global x position of last spawned wall
var last_spawn_x: float
## Global x position of next wall to spawn
var next_spawn_x: float
## Ammount of walls spawned
var spawned: int = 1
## Phase of the game, determines which enemies will show up
## Phase 1: s300 walls
## Phase 2: ghost of Kyiv
var phase: int = 1

func _init():
	Game.game_ref = self

func _ready():
	state = STATE.INI
	load_game()
	if bird:
		bird.died.connect(_on_bird_died)
	if ui:
		hud = ui.hud
	$AudioMusic.volume_db = -60
	Global.back_pressed.connect(_on_back)
	music_fade_in()
	await get_tree().create_timer(3.4).timeout
	play()

func play():
	state = STATE.PLAY
	bird.play()
	last_spawn_x = -1000
	next_spawn_x = 0
	spawn_timer.start()
	

func load_game():
	Global.load_game()

func save_game():
	Global.save_game()

func music_fade_in():
	music_tween = create_tween()
	music_tween.tween_property($AudioMusic, "volume_db", Global.music_volume, 2)

func music_fade_out():
	music_tween = create_tween()
	music_tween.tween_property($AudioMusic, "volume_db", Global.music_volume_min, 2)

func _on_bird_died():
	print('bird dead')
	state = STATE.GAME_OVER
	spawn_timer.stop()
	if score > Global.high: Global.high = score
	Global.update_score.emit()
	save_game()
	await get_tree().create_timer(3).timeout
	on_game_over()

func on_game_over():
	music_fade_out()
	Global.show_game_over.emit()

func reset():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_spawn_timer_timeout():
	if state == STATE.GAME_OVER: return
	match phase:
		1:
			phase_one_spawner()
		2:
			phase_two_spawner()
	
## Handles phase one spawning
func phase_one_spawner():
	var phase_one_max: int = 25
	if cam.global_position.x >= next_spawn_x:
		spawn_wall()
		var difficulty: float = clampf(spawned * 1.2 / float(phase_one_max), 0, 1)
		var next_min := lerpf(430, 310, difficulty)
		var next_max := lerpf(600, 350, difficulty)
		var next := randf_range(next_min, next_max)
		last_spawn_x = cam.global_position.x
		next_spawn_x = last_spawn_x + next
		print('game spawned next: %s, min: %s, max: %s, spanwed: %s' % [next, next_min, next_max, spawned])
		if spawned == 19:
			spawn_minigok()
	if spawned == phase_one_max:
		start_phase_two()

func start_phase_two():
	phase = 2
	last_spawn_x = cam.global_position.x
	next_spawn_x = last_spawn_x + 2400
	await get_tree().create_timer(12).timeout
	audio_music.stream = load("res://assets/audio/music/gok theme.ogg")
	audio_music.play()
	print('main start phase 2')

## Handles spawning for phase 2. Called every spawn timeout.
func phase_two_spawner():
	var phase_one_max: int = 25
	var phase_two_max: int = 90
	if cam.global_position.x >= next_spawn_x:
		spawn_gok()
		var difficulty: float = clampf((spawned - phase_one_max) / float((phase_two_max - phase_one_max) / 2.0), 0, 1)
		if difficulty > 0.18 and spawned % 5 == 0:
			spawn_wall()
		if difficulty > 0.3 and spawned % 4 == 0:
			spawn_gok(-1)
		var next_min := lerpf(800, 110, difficulty)
		var next_max := lerpf(800, 350, difficulty)
		var next := randf_range(next_min, next_max)
		last_spawn_x = cam.global_position.x
		next_spawn_x = last_spawn_x + next
		print('game spawned gok diff: %s, next: %s, min: %s, max: %s, spanwed: %s' % [difficulty, next, next_min, next_max, spawned])

## Spawns an S300 wall and TEL
func spawn_wall():
	if not bird: return
	var wall: Wall = wall_scene.instantiate() as Wall
	wall.position.x = bird.position.x + 1600
	$walls.add_child(wall)
	spawned += 1

## Spawns a Ghost of Kyiv, speed multiplied by speed_multiplier
func spawn_gok(speed_multiplier: float = 1):
	if not bird: return
	var enemy: Gok = gok_scene.instantiate() as Gok
	enemy.position.x = bird.position.x + 1600 * clampf(speed_multiplier, -1, 1)
	var ymin = -250
	var ymax = 250
	var new_y = randf_range(ymin, ymax) + 400
	enemy.global_position.y = new_y
	enemy.speed *= speed_multiplier
	enemy.scale.x *= clampf(speed_multiplier, -1, 1)
	$walls.add_child(enemy)
	spawned += 1

## Spawns a small ghost of Kyiv in the background moving right
func spawn_minigok():
	if not bird: return
	var enemy: Gok = gok_scene.instantiate() as Gok
	enemy.position.x = bird.position.x - 750
	enemy.global_position.y = 300
	enemy.scale = Vector2(-0.2, 0.2)
	enemy.speed = 225
	enemy.modulate = Color(0.5, 0.5, 0.7)
	enemy.set_collision_enabled(false)
	$walls.add_child(enemy)
	
## Speeds up music by given speed ratio. Sets pitch scale.
func set_music_speed(speed: float):
	audio_music.pitch_scale = speed
	if speed > 1:
		audio_music.volume_db = Global.music_volume - 12
	else:
		audio_music.volume_db = Global.music_volume
	

func add_score():
	if state != STATE.PLAY: return
	score += 1
	print('scored: %d' % score)
	Global.update_score.emit()
		
func pause_clicked():
	%AudioClick.play()
	get_tree().paused = !get_tree().paused
	if state == STATE.GAME_OVER: return
	if get_tree().paused:
		Global.show_pause.emit()
	else:
		Global.hide_pause.emit()

func _on_back():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/opening.tscn")

func _notification(what):
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
		print("focus in")
	elif what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
		print("focus out")
		if not get_tree().paused:
			pause_clicked()


func _on_audio_music_finished():
	print('main audiomusic finished')
