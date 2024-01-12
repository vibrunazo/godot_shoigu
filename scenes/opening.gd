extends CanvasLayer

var state: STATE = STATE.INI
enum STATE {
	INI,
	PLAY,
	PAUSED
}

var music_volume_min: = -64
var music_volume_max: = -12
var music_volume: = -12

func _ready():
	$VideoTalkLoop.finished.connect(on_talk_loop_finished)
	Global.show_credits.connect(_on_show_credits)
	Global.back_pressed.connect(_on_hide_credits)
	Global.show_pause.connect(_on_pause_pressed)
	$AudioMusicLoop.volume_db = -60
	music_fade_in($AudioMusicLoop)
	$BirdIntro.visible = false
	
func _unhandled_input(event):
	if event.is_action("ui_skip"):
		end()
	if state != 0: return
	if event.is_action("ui_accept") || event.is_action("flap"):
		%ButtonSettings.hide()
		play()
	

func play():
	state = STATE.PLAY
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
	end()
		
func on_talk_loop_finished():
	$VideoTalkLoop.play()

func end():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
func music_fade_in(widget, duration = 2):
	var tween = create_tween()
	tween.tween_property(widget, "volume_db", music_volume, duration)

func music_fade_out(widget, duration = 2):
	var tween = create_tween()
	tween.tween_property(widget, "volume_db", -60, duration)

func _on_pause_pressed():
	if state == STATE.PLAY: return
	$AudioClick.play()
	%CreditsPanel.hide()
	if state == STATE.INI:
		%IntroMenu.visible = true
		%LabelClick.hide()
		get_tree().paused = true
		state = STATE.PAUSED
	elif state == STATE.PAUSED:
		%IntroMenu.visible = false
		%LabelClick.show()
		get_tree().paused = false
		state = STATE.INI

func _on_show_credits():
	%IntroMenu.hide()
	%CreditsPanel.show()

func _on_hide_credits():
	%IntroMenu.show()
	%CreditsPanel.hide()
