extends Area2D

var t_distance = 0
func _physics_process(delta):
	const SPD = 2500
	const RNG = 1200
	
	var direc = Vector2.RIGHT.rotated(rotation)
	position += direc * SPD * delta
	
	t_distance += SPD*delta
	if t_distance>RNG:
		queue_free()


func _on_body_entered(body):
	var dmg = 1
	if get_parent().has_method("return_dmg"):dmg = get_parent().return_dmg()
	queue_free()
	if body.has_method("t_dmg"):body.t_dmg(dmg)
