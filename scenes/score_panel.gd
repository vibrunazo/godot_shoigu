extends MarginContainer

class_name ScorePanel

@onready var game: Game = Game.game_ref

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	Global.update_score.connect(update)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update():
	%LabelNew.visible = game.score >= game.high
	%LabelScore.text = "%d" % game.score
	%LabelHigh.text = "%d" % game.high
