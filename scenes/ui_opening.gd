extends Control


func _unhandled_input(event):
	if event.is_action_pressed("ui_pause"):
		Global.show_pause.emit()
