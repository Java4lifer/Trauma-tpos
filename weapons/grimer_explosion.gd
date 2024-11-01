extends Area2D


var things =[]
var atk = false
var scan = true
func _physics_process(_delta):
	#var hit_targets = []
	if scan:things = get_overlapping_bodies();scan=false
	if things.size() > 0:
		if atk==true:for mob in things:
			if mob.has_method("t_dmg"):mob.t_dmg(25);things.erase(mob)
			#if player.has_method("stun_p"):
			#player.stun_p(4)

func regist():
	atk = true
	$channel3.play(0.4)
	await get_tree().create_timer(1).timeout
	queue_free()
func _ready():
	var playercam = get_node("/root/MainFrame/player").get_child(0)
	%AnimationPlayer.play("explode")
	regist()
	if playercam:
			playercam.set_shake_fade(5)
			playercam.set_rstrength(20)
			playercam.apply_shake()
	
