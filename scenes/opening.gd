extends CanvasLayer

var state: int = 0
var music_tween: Tween

var music_volume_min: = -64
var music_volume_max: = -12
var music_volume: = -12

func _ready():
	$VideoTalkLoop.finished.connect(on_talk_loop_finished)
	$AudioMusicLoop.volume_db = -60
	music_fade_in()
	$BirdIntro.visible = false

#func _process(delta):
#	print($AudioMusicLoop.get_playback_position())
	
func _input(event):
	if state != 0: return
	if event.is_action("ui_accept") || event.is_action("flap"):
		play()

func play():
	state = 1
	$AnimClick.play("clicked")
	$AudioMusicLoop.get_stream().loop = false
	await $AudioMusicLoop.finished
	$AudioMusicIntro.play()
#	await  $AudioMusicIntro.finished
	await get_tree().create_timer(13).timeout
	$Anim.play("fade_out")
	$VideoStreamPlayer.play()
	await get_tree().create_timer(4).timeout
	$AnimShoigu.play("start")
	$AudioMusicMain.play()
	await get_tree().create_timer(5).timeout
	music_fade_out()
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://scenes/main.tscn")
		
func on_talk_loop_finished():
	$VideoTalkLoop.play()

	
func music_fade_in():
	music_tween = create_tween()
	music_tween.tween_property($AudioMusicLoop, "volume_db", music_volume, 2)

func music_fade_out():
	music_tween = create_tween()
	music_tween.tween_property($AudioMusicMain, "volume_db", music_volume_min, 2)
