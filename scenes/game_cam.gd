extends Camera2D

@export var target: Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not target or target.state == 2: return
	position.x = target.global_position.x + 300

func _on_area_2d_body_entered(body):
	if body is Floor:
		body.reset()
	if body.get_parent() is Wall:
		body.get_parent().queue_free()
