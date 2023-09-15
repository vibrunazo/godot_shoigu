extends Control

class_name Hud

var color_text: String = 'ffc'
var color_score: String = 'ff3'

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	set_score(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_score(new_score: int):
	%ScoreLabel.text = '[color=%s]Score[/color] [color=%s]%d[/color]' % [color_text, color_score, new_score]
