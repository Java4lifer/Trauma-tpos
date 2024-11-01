extends Node2D
#func _process(delta: float) -> void:
	#if !$AudioStreamPlayer2D.is_playing():
		#$AudioStreamPlayer2D.stream = CorrectSound
		#$AudioStreamPlayer2D.play()
		
@onready var spawners = [%spawner_mob, %spawner_mob2, %spawner_mob3, %spawner_mob8]
@onready var spawners2 = [%spawner_mob4, %spawner_mob5, %spawner_mob6, %spawner_mob7]
@onready var givers = %wep_givers.get_children()


@onready var mobs =  %mob_list
@onready var bsm =  %black_silence
@onready var pspawn = [%spawner_player, %spawner_player2]
@onready var cycle_t = %stats/cycle
@onready var round_t = %stats/round

var player
var roland = true
func _ready():
	player = Global.get_player()
	player.global_position = %initial_position.position
	add_child(player)
	player = $player
	
	if Global.get_saved():
		cycle_n = Global.get_stats()
		round_n = 1
	player.no_hp.connect(_on_player_no_hp)
	
	if Global.get_gun():
		player.set_gun(Global.get_gun(), 'gun')
		
		for wep in givers:
			if wep.get_wepper():
				if wep.get_wepper().name == player.getter_gun().name:
					wep.set_bought(true)
	if Global.get_swo():
		player.set_gun(Global.get_swo(), 'swo')
		for wep in givers:
			if wep.get_wepper():
				if wep.get_wepper().name == player.getter_swo().name:
					wep.set_bought(true)

var cycle_n = 0
var round_n = 0
func refresh_labels():
	cycle_t.text = "Cycle: "+str(cycle_n)
	round_t.text = "Round: "+str(round_n)

var enemies = 0

func spawn_mob(mobtype:String, enemy_n:int, spawner_n:int):
	var path = "res://enemies/"+mobtype+".tscn";var newmob = load(path)
	var bros = 0;var spn_n = 0
	if enemy_n >3: bros = 3
	else: bros = enemy_n
	
	for i in range(bros+1):
		var nmob = newmob.instantiate()
		if spawner_n == 2:
			nmob.global_position = spawners2[spn_n].position
		else:
			nmob.global_position = spawners[spn_n].position
		if round_n == 5:
			if nmob.has_method("make_boss"):nmob.make_boss(cycle_n)
			nmob.scale = Vector2(2,2)
			if cycle_n == 0:
				if nmob.has_method("buff_hp"):nmob.buff_hp(5)
			else:
				if nmob.has_method("buff_hp"):nmob.buff_hp(cycle_n*10)
		else:
			if nmob.has_method("buff_hp"):nmob.buff_hp(cycle_n)
		if mobtype == "blacksilence" or mobtype == "bsfight/roland_bygone":bsm.call_deferred("add_child", nmob)
		else:mobs.call_deferred("add_child", nmob)
		if mobtype == "roland_phase2":real_blacksilence = nmob
		spn_n += 1

func _on_player_no_hp():
	%gameOver.visible = true
	%audioChannel1.stream_paused = true
	#%black_silence.call_deferred("queue_free")
	#%mob_list.call_deferred("queue_free")
	get_tree().paused = true
	Global.set_fused(false)
	#await get_tree().create_timer(4).timeout

var dash_round = null
var shoot_round = null
var rounded = RandomNumberGenerator.new()
func _on_door_body_entered(_body):
	if player.getter_gun():
		for bullet in $player/inv_gun.get_child(0).get_bullets():bullet.queue_free()
		Global.store_player(player)
		#if roland == true and round_n == 0:
			#spawn_mob("blacksilence", 0, 1)
		#if cycle_n == 14 and roland == true: spawn_mob("blacksilence", 0, 1)
		if Global.get_saved():
			refresh_labels()
			if cycle_n > 0:
				rounded.randomize()
				dash_round = 1+rounded.randi()%5;shoot_round = 1+rounded.randi()%5
				if cycle_n == 14 and roland == true: spawn_mob("blacksilence", 0, 1)
				elif round_n == dash_round: spawn_mob("dasher", 0, 1)
				elif round_n == shoot_round: spawn_mob("shooter", 0, 1)
				else: spawn_mob("mob", 0, 1)
			else:
				spawn_mob("mob", 0, 1)
		%audioChannel1.play()
		player.t_dmg(0)
		player.global_position = pspawn[0].global_position
		%stats.visible = true


func _on_door_1_body_entered(_body):
	if enemies == 0:
		player.t_dmg(0)
		for bullet in $player/inv_gun.get_child(0).get_bullets():bullet.queue_free()
		player.global_position = pspawn[0].global_position
		if roland == true:
			Global.store_stats(cycle_n)
		
		if round_n == 5:
			Global.store_player(player)
			rounded.randomize()
			dash_round = 1+rounded.randi()%5;shoot_round = 1+rounded.randi()%5
			round_n = 0;cycle_n += 1
			Global.store_stats(cycle_n)
		
		elif round_n == 4:
			for bullet in $player/inv_gun.get_child(0).get_bullets():bullet.queue_free()
			%audioChannel1.stream_paused = true
			player.set_hp(player.get_hp(2))
			player.t_dmg(0)
			player.global_position = pspawn[1].global_position
			return
		
		elif round_n == 3:
			round_n += 1
			var cycy = cycle_n
			if cycle_n > 5: cycy = 4
			elif cycle_n > 2: cycy = 2
			if dash_round == 5:spawn_mob("dasher", cycy, 1)
			elif shoot_round == 5:spawn_mob("shooter", cycy, 2)
			elif dash_round == 5 and shoot_round == 5:
				spawn_mob("dasher", cycy, 1)
				spawn_mob("shooter", cycy, 2)
			else: spawn_mob("mob", cycy, 1)
			refresh_labels()
			return

		round_n += 1
		refresh_labels()
		if cycle_n == 14 and round_n == 1 and roland == true: spawn_mob("blacksilence", 0, 1)
		elif round_n == dash_round: spawn_mob("dasher", 0, 1)
		elif round_n == shoot_round: spawn_mob("shooter", 0, 1)
		else: spawn_mob("mob", 0, 1)
	else:
		pass

func _on_door_2_body_entered(_body):
	round_n += 1
	refresh_labels()
	player.t_dmg(0)
	player.global_position = pspawn[0].global_position
	for bullet in $player/inv_gun.get_child(0).get_bullets():bullet.queue_free()
	if round_n == dash_round: spawn_mob("dasher", 0, 1)
	elif round_n == shoot_round: spawn_mob("shooter", 0, 1)
	else: spawn_mob("mob", 0, 1)
	%audioChannel1.stream_paused = false

func _on_mob_list_child_entered_tree(_node):
	var mobss = 0
	for enemy in mobs.get_children():
		mobss+=1
	enemies = mobss
func _on_mob_list_child_exiting_tree(_node):
	enemies-=1

#get_node("door").queue_free()
#get_node("world_box").queue_free()
#Global.store_player(player)
#remove_child(player)
#var next_level = preload("res://maps/level_1.tscn").instantiate()
#next_level.add_child(Global.get_player())
#get_tree().root.add_child(next_level)
#WTF
var real_blacksilence
func _on_black_silence_child_exiting_tree(node):
	if node.has_method("get_is_blacksilence1"):
		Global.set_bs(2)
		spawn_mob("roland_phase2", 0, 1)
	if node.has_method("get_is_bygone"):real_blacksilence.less_bygones()
func _on_black_silence_child_entered_tree(_node):
	enemies = 1
