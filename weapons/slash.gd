extends Area2D

var inrange = []
var dmg = 3
var atk = true
func _physics_process(_delta):
	inrange = get_overlapping_bodies()
	if inrange.size() > 0:
		print("Found", inrange.size(),"people.")
		%AnimationPlayer.play("simple")
		if atk == true: for slime in inrange:
			atk = false
			if slime.has_method("t_dmg"): slime.t_dmg(dmg)
			$Timer.start()


#func _on_body_entered(body): enemy_in_line.append(body)
#
#
#func _on_body_exited(body): enemy_in_line.slice(enemy_in_line.find(body, 0))


func _on_timer_timeout(): atk = true
