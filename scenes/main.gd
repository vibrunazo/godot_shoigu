extends Control

class_name Game

@export var bird: Bird
@export var ui: UI
@export var wall_scene: PackedScene
@onready var hud: Hud


static var game_ref: Game
var score: int = 0
# ellapsed time in seconds, updated at every spawn
var time: float = 0
var state: STATE = STATE.INI
enum STATE {
	INI,
	PLAY,
	GAME_OVER
}
var music_tween: Tween

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
	$SpawnTimer.start()

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
	$SpawnTimer.stop()
	if score > Global.high: Global.high = score
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
	spawn_wall()
	var min_time = 2.0
	var max_time = 4.5
	if time > 20:
		min_time = 1.9
		max_time = 3.0
	var next_time = randf_range(min_time, max_time)
	time += next_time
	$SpawnTimer.start(next_time)

func spawn_wall():
	if not bird: return
	var wall: Node2D = wall_scene.instantiate()
	$walls.add_child(wall)
	wall.position.x = bird.position.x + 1600
	wall.position.y += randf_range(-350, 400) + 400

func add_score():
	if state != STATE.PLAY: return
	score += 1
	print('scored: %d' % score)
	Global.update_score.emit()
		
func pause_clicked():
	get_tree().paused = !get_tree().paused
	if state == STATE.GAME_OVER: return
	if get_tree().paused:
		Global.show_pause.emit()
	else:
		Global.hide_pause.emit()

func _on_back():
	get_tree().change_scene_to_file("res://scenes/opening.tscn")
	get_tree().paused = false

func _notification(what):
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
		print("focus in")
	elif what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
		print("focus out")
		pause_clicked()
