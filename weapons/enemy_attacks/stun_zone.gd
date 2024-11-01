extends Area2D

var line:Sprite2D
var things
func _ready():
	line = %line
func _process(_delta):
	things = get_overlapping_bodies()

func hit_target(x):
	line.visible = false
	$Timer.start()
	if things.size() > 0:
		for stuff in things:
			if stuff.has_method("stun_p"):stuff.stun_p(x)
		return true;
	else: return false;
	


func _on_timer_timeout():
	queue_free()
