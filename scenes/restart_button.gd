extends Button


func _on_pressed():
	var game = Game.game_ref
	if game:
		game.reset()
