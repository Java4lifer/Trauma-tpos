extends ColorRect


func _process(_delta):
	if %retry.button_pressed:
		get_tree().paused = !get_tree().paused
		get_tree().reload_current_scene()
