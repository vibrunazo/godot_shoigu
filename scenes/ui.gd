extends CanvasLayer

class_name UI

@onready var hud = $HUD
@onready var game_over: GameOver = $GameOver

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.show_game_over.connect(on_game_over)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func on_game_over():
	game_over.start()
	hud.end()
