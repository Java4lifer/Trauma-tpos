extends ColorRect

func _process(_delta):
	if Input.is_key_pressed(KEY_ESCAPE) and get_tree().paused == false:
		%pause_menu.visible = !%pause_menu.visible
		get_tree().paused = true
		
	if $resume.button_pressed:
		%pause_menu.visible = !%pause_menu.visible
		get_tree().paused = !get_tree().paused
	if $exit.button_pressed:
		get_tree().quit()
