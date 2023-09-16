extends Control

class_name Hud

var color_text: String = 'ffc'
var color_score: String = 'ff3'
var game: Game

# Called when the node enters the scene tree for the first time.
func _ready():
	game = Game.game_ref
	set_score(0)


func _unhandled_key_input(event):
	if event.is_action_pressed("ui_toggle_fullscreen"):
		game.toggle_fullscreen()
	if event.is_action_pressed("ui_pause"):
		game.pause_clicked()

func set_score(new_score: int):
	%ScoreLabel.text = '[color=%s]Score[/color] [color=%s]%d[/color]' % [color_text, color_score, new_score]


func _on_button_pressed():
	game.pause_clicked()
	
	
