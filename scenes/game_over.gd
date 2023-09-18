extends Control

@onready var game: Game = Game.game_ref

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	$Panel.modulate.a = 0

func start():
	visible = true
	$Anim.play("start")
	var score = game.score
	%LabelScore.text = "%d" % score
	%LabelHigh.text = "%d" % score
