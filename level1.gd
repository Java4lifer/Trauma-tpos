extends Node2D

@onready var door = get_node("door")
#@onready var player = get_node("player")
@onready var spawner = get_node("mob_spawn/CollisionShape2D")
@onready var mobs = get_node("mobs")

#-546,-49 teleport to
var enemies = 0

func count_enemies():
	for enemy in mobs.get_children():
		enemies+=1

func spawn_mob():
	var newmob = preload("res://enemies/mob.tscn").instantiate()
	newmob.global_position = spawner.global_position
	mobs.add_child(newmob)

func _on_door_body_entered(body):
	if enemies == 0:
		body.global_position = Vector2(-546,-49)
		spawn_mob()
		count_enemies()
	else:
		pass


func _on_player_no_hp():
	%gameOver.visible = true
	get_tree().paused = true
	await get_tree().create_timer(4).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()
