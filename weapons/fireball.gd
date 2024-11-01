extends Area2D

var t_distance = 0
func _physics_process(delta):
	const SPD = 1000
	const RNG = 1200
	
	var direc = Vector2.RIGHT.rotated(rotation)
	position += direc * SPD * delta
	
	t_distance += SPD*delta
	if t_distance>RNG:
		queue_free()


var explosion = preload("res://weapons/grimer_explosion.tscn")
func _on_body_entered(body):
	var dmg = 1
	if get_parent().has_method("return_dmg"):dmg = get_parent().return_dmg()
	if body.has_method("t_dmg"):body.t_dmg(dmg)
	var explos = explosion.instantiate()
	explos.global_position = global_position
	get_parent().call_deferred("add_child", explos)
	queue_free()
