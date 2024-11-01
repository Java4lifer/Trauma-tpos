extends Area2D

var atk = true
var dmg = 30
func toggle(bol):
	atk = bol
func set_dmg(x):
	dmg = x

func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if atk == true:
		atk = false
		if body.has_method("t_dmg"):
			if get_parent().has_method("get_is_bygone"):
				body.t_dmg(8)
			else: body.t_dmg(dmg)
