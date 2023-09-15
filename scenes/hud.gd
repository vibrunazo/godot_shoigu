extends Control

class_name Hud

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	set_score(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_score(new_score: int):
	%ScoreLabel.text = 'Score [b]%d[/b]' % new_score
