extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_credits_button_pressed():
	Global.show_credits.emit()

func _on_visibility_changed():
	if is_visible_in_tree():
		%CreditsButton.grab_focus()
