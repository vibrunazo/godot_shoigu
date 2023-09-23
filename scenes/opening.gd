extends CanvasLayer

var state: int = 0

var music_volume_min: = -64
var music_volume_max: = -12
var music_volume: = -12

func _ready():
	$VideoTalkLoop.finished.connect(on_talk_loop_finished)
	Global.show_credits.connect(_on_show_credits)
	Global.show_pause.connect(_on_pause_pressed)
	$AudioMusicLoop.volume_db = -60
	music_fade_in($AudioMusicLoop)
	$BirdIntro.visible = false
	
func _unhandled_input(event):
	if state != 0: return
	if event.is_action("ui_accept") || event.is_action("flap"):
		%ButtonSettings.hide()
		play()

func play():
	state = 1
	$AnimClick.play("clicked")
	$AudioMusicLoop.get_stream().loop = false
#	await $AudioMusicLoop.finished
	await get_tree().create_timer(1).timeout
	music_fade_out($AudioMusicLoop)
	music_fade_in($AudioMusicIntro, 5)
	$AudioMusicIntro.play()
#	await  $AudioMusicIntro.finished
	await get_tree().create_timer(5).timeout
	$Anim.play("fade_out")
	$VideoStreamPlayer.play()
	await get_tree().create_timer(4.1).timeout
	$AnimShoigu.play("start")
	$AudioMusicMain.play()
	await get_tree().create_timer(5).timeout
	music_fade_out($AudioMusicMain, 6)
	await get_tree().create_timer(2.5).timeout
	get_tree().change_scene_to_file("res://scenes/main.tscn")
		
func on_talk_loop_finished():
	$VideoTalkLoop.play()

	
func music_fade_in(widget, duration = 2):
	var tween = create_tween()
	tween.tween_property(widget, "volume_db", music_volume, duration)

func music_fade_out(widget, duration = 2):
	var tween = create_tween()
	tween.tween_property(widget, "volume_db", -60, duration)


func _on_pause_pressed():
	$AudioClick.play()
	if state == 0:
		%IntroMenu.visible = true
		get_tree().paused = true
		state = 2
	elif state == 2:
		%IntroMenu.visible = false
		get_tree().paused = false
		state = 0

func _on_show_credits():
	print('show credits')
