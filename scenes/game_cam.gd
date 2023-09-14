extends Camera2D

@export var target: Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = target.global_position.x


func _on_area_2d_body_entered(body):
	if body is Floor:
		print('%s entered' % body)
		body.reset()
	pass # Replace with function body.
