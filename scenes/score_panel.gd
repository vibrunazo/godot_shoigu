extends MarginContainer

class_name ScorePanel

@onready var game: Game = Game.game_ref

func _ready():
	Global.update_score.connect(update)

func update():
	%LabelNew.visible = game.score >= Global.high
	%LabelScore.text = "%d" % game.score
	%LabelHigh.text = "%d" % Global.high
