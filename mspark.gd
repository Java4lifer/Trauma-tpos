extends Area2D

var line:Sprite2D
var spp:Sprite2D
var atk = false
func _ready():
	line = %line
	spp = %master_spark_sprite
func _physics_process(delta):
	var things = get_overlapping_bodies()
	if things.size() > 0:
		if atk == true: for player in things:
			#if player.has_method("stun_p"):
			player.stun_p(1)
			if player.has_method("t_dmg"):player.t_dmg(10*delta)
			
func fire_spell():
	line.visible = false
	spp.visible = true
	atk = true
	await get_tree().create_timer(1).timeout
	while spp.scale.y > 0:
		spp.scale.y -= 0.05
		%CollisionShape2D.scale -= Vector2(0,05)
		await get_tree().create_timer(0.05).timeout
	atk = false
	queue_free()
