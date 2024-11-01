extends Area2D

@onready var pl = Global.get_player()

func _process(_delta):
	if %sim.button_pressed:
		if pl.get_g() >= 50:
			pl.set_g(pl.get_g()-50)
			if pl.has_method("set_hp"): pl.set_hp(100)
		$menu.visible = false
		pl.set_speed(600)
	elif %nao.button_pressed:$menu.visible = false;pl.set_speed(600)

func _on_body_entered(body):
	$menu.visible = true
	body.set_speed(0)
