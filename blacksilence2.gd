extends CharacterBody2D

func play_hurt():
	%anim.play("RESET")
	%anim.queue("hurt")
	%anim.queue("RESET")
	
func get_is_blacksilence2():return true
	
var hp = 500
var dead = false
var mhp = hp
var wspeed = 0
var dmg = 5
var atk = false
var atk2 = false
func get_dmg(): return dmg
func get_hp(): return hp
func u_hp():
	%hpbar.max_value=mhp;%hpbar.value=hp
	%hpbar/ahp.text=str(hp)+"/"+str(mhp)
var rounded = RandomNumberGenerator.new()

var pl;var mainsong;var smile;var spawn;var game
#or, @onready var player = get_node(yada yada
func _ready():
	spawn = get_node("../../mob_spawn/spawner_mob8")
	mainsong = get_node("/root/MainFrame/audioChannel1")
	game = get_node("/root/MainFrame")
	if mainsong: mainsong.stream_paused = true
	$whispers.play()
	pl = get_node("/root/MainFrame/player")
	%fade.play("revel2")
	u_hp()
	%hpbar.visible = true
	await get_tree().create_timer(4).timeout
	$gone_angels.play()
	

var direction
func _physics_process(_delta):
	direction = Vector2.from_angle(%aim.rotation)
	velocity = direction * wspeed
	move_and_slide()
	if %aim/weapon.global_position.x > global_position.x:
		%aim/RolandAtelier.flip_v = false
		%aim/RolandWheels.flip_v = false
	else:
		%aim/RolandAtelier.flip_v = true
		%aim/RolandWheels.flip_v = true
	
	var things = %attack_area.get_overlapping_bodies()
	if things.size() > 0:
		if atk == true: for player in things:
			if player == pl:
				atk = false
				if player.has_method("t_dmg"):player.t_dmg(dmg)
	
		
#var poss = -1
func dash():
	if dead == false:
		rounded.randomize()
		var recoil = rounded.randf_range(-360, 360)
		%aim.rotation = recoil
		wspeed = 1000
		await get_tree().create_timer(0.5).timeout
		wspeed = 0
		%reload.start()

func shoot(scall):
	if dead == false:
		rounded.randomize()
		var recoil = rounded.randf_range(-0.3, 0.3)
		const BUL = preload("res://weapons/enemy_attacks/ebullet_1.tscn")
		var new_bul = BUL.instantiate()
		%aim.look_at(pl.global_position)
		new_bul.global_position = %aim/weapon.global_position
		new_bul.global_rotation = %aim/weapon.global_rotation+recoil
		if scall>1:
			new_bul.scale = Vector2(scall, scall)
		if dead == false:
			%aim/weapon.add_child(new_bul)
	

func crystal():
	#await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.disabled = true
	$weapons/RolandCrystal.visible=true
	await get_tree().create_timer(0.5).timeout
	for i in range(2):
		%click.play()
		if dead == false:
			for x in range(2):
				%aim.look_at(pl.global_position)
				atk = true
				if dead == false:
					wspeed = 2200
				await get_tree().create_timer(0.4).timeout
				wspeed = 0
				atk = false
				await get_tree().create_timer(0.28).timeout
		await get_tree().create_timer(0.2).timeout
	$weapons/RolandCrystal.visible=false
	%aim.look_at(spawn.global_position)
	wspeed = 1800
	await get_tree().create_timer(0.4).timeout
	wspeed = 0
	$CollisionShape2D.disabled = false
	await get_tree().create_timer(0.4).timeout
	
func atellier():
	%aim/weapon.set_dmg(3)
	%click.play()
	%aim/RolandAtelier.visible = true
	await get_tree().create_timer(0.6).timeout
	for i in range(5):
		$atellier.play()
		shoot(1)
		await get_tree().create_timer(0.2).timeout
	await get_tree().create_timer(0.2).timeout
	rounded.randomize()
	var recoil = rounded.randf_range(-360, 360)
	%aim.rotation = recoil
	wspeed = 1600
	await get_tree().create_timer(0.5).timeout
	wspeed = 0
	for i in range(8):
		$atellier.play()
		shoot(1)
		await get_tree().create_timer(0.1).timeout
	%aim/RolandAtelier.visible = false
	
	
const crack = preload("res://weapons/enemy_attacks/ground_slam.tscn")
func wheels():
	#spawns a destruction object and plays some noise, that's it
	%aim/RolandWheels.visible = true
	for i in range(2):
		%click.play()
		%aim.look_at(pl.global_position)
		wspeed = 1750
		await get_tree().create_timer(0.45).timeout
		wspeed = 0
		var new_hole = crack.instantiate()
		new_hole.global_position = %aim/weapon.global_position
		await get_tree().create_timer(0.5).timeout
		add_child(new_hole)
		$wheels.play()
		var playercam = pl.get_child(0)
		if playercam:
			playercam.set_shake_fade(10)
			playercam.set_rstrength(30)
			playercam.apply_shake()
		await get_tree().create_timer(0.1).timeout
		if new_hole.has_method("toggle"): new_hole.toggle(false)
		await get_tree().create_timer(0.5).timeout
	%aim/RolandWheels.visible = false
	
func blaster():
	%click.play()
	var spark = preload("res://assets/mspark_attack.tscn").instantiate()
	spark.global_position = global_position
	%aim.look_at(pl.global_position)
	spark.rotation = %aim.rotation
	if dead == false:
		%aim.call_deferred("add_child", spark)
		await get_tree().create_timer(0.5).timeout
		spark.fire_spell()
		var playercam = pl.get_child(0)
		if playercam:
			playercam.set_shake_fade(3)
			playercam.set_rstrength(30)
			playercam.apply_shake()
	await get_tree().create_timer(3).timeout

func duran():
	var targets
	%click.play()
	%aim/RolandDurandal.visible = true
	await get_tree().create_timer(0.6).timeout
	for i in range(2):
		%aim.look_at(pl.global_position)
		wspeed = 1750
		await get_tree().create_timer(0.3).timeout
		wspeed = 0
		%aim.look_at(pl.global_position)
		$anim.play("slash_durandal")
		$anim.queue("RESET")
		await get_tree().create_timer(0.2).timeout
		targets = %aim/RolandDurandal/hitbox.get_overlapping_bodies()
		for target in targets:
			if target:
				if target.has_method("t_dmg"):target.t_dmg(10)
		await get_tree().create_timer(0.15).timeout
		%aim.look_at(pl.global_position)
		targets = %aim/RolandDurandal/hitbox.get_overlapping_bodies()
		for target in targets:
			if target:
				if target.has_method("t_dmg"):target.t_dmg(10)
	await get_tree().create_timer(0.8).timeout
	%aim/RolandDurandal.visible = false
	pass

func ranga():
	%click.play()
	%aim/RolandRanga.visible = true
	var mdmg = dmg
	dmg = 8
	await get_tree().create_timer(0.6).timeout
	for i in range(2):
		atk = true
		%ranga_anchor.global_position = global_position
		%aim.look_at(pl.global_position)
		wspeed = 2050
		await get_tree().create_timer(0.26).timeout
		wspeed = 0
		await get_tree().create_timer(0.2).timeout
		%aim.look_at(%ranga_anchor.global_position)
		wspeed = 2050
		await get_tree().create_timer(0.26).timeout
	wspeed = 0
	%aim/RolandRanga.visible = false
	%aim/RolandRanga2.visible = true
	await get_tree().create_timer(0.2).timeout
	atk = true
	%aim.look_at(pl.global_position)
	wspeed = 2250
	await get_tree().create_timer(0.4).timeout
	wspeed = 0
	await get_tree().create_timer(1).timeout
	%aim/RolandRanga2.visible = false
	dmg = mdmg
	atk = false
	pass

func furioso():
	%click.play()
	var fury = preload("res://weapons/enemy_attacks/stun_zone.tscn").instantiate()
	%aim.look_at(pl.global_position)
	fury.global_position = global_position;fury.rotation = %aim.rotation
	%aim.call_deferred("add_child", fury)
	await get_tree().create_timer(1).timeout
	var hass = fury.hit_target(5)
	if hass == true:
		%aim.look_at(pl.global_position)
		wspeed = 2000
		await get_tree().create_timer(0.2).timeout
		wspeed = 0
#PLEASE, EXCHANGE FOR LIKE, crystal(dash = false) and it turns into the furioso version, THIS SUCKS
		%click.play()
		%aim/RolandAtelier.visible = true
		%aim/weapon.set_dmg(4)
		for i in range(2):shoot(1);await get_tree().create_timer(0.4).timeout
		%aim/RolandAtelier.visible = false
		
		%click.play()
		$CollisionShape2D.disabled = true
		%aim/RolandRanga.visible = true
		var mdmg = dmg
		dmg = 8
		atk = true

		%aim.look_at(pl.global_position)
		wspeed = 2050
		await get_tree().create_timer(0.3).timeout
		wspeed = 0
		await get_tree().create_timer(0.1).timeout
		%aim.look_at(pl.global_position)
		atk = true
		wspeed = 2050
		await get_tree().create_timer(0.3).timeout
		wspeed = 0
		%aim/RolandRanga.visible = false
		$CollisionShape2D.disabled = false
		dmg = mdmg
		atk = false
		
		$CollisionShape2D.disabled = true
		$weapons/RolandCrystal.visible=true
		await get_tree().create_timer(0.5).timeout
		for i in range(2):
			%click.play()
			for x in range(2):
				%aim.look_at(pl.global_position)
				atk = true
				if dead == false:
					wspeed = 2200
				await get_tree().create_timer(0.4).timeout
				wspeed = 0
				atk = false
				await get_tree().create_timer(0.1).timeout
		$weapons/RolandCrystal.visible=false
		dmg = mdmg
		
		%click.play()
		%aim/RolandWheels.visible = true
		%aim.look_at(pl.global_position)
		var new_hole = crack.instantiate()
		new_hole.global_position = %aim/weapon.global_position
		await get_tree().create_timer(0.5).timeout
		new_hole.set_dmg(16)
		add_child(new_hole)
		$wheels.play()
		await get_tree().create_timer(0.3).timeout
		new_hole.toggle(false)
		await get_tree().create_timer(1).timeout
		%aim/RolandWheels.visible = false
		
		$CollisionShape2D.disabled = true
		var targets
		%click.play()
		%aim/RolandDurandal.visible = true
		for i in range(2):
			%aim.look_at(pl.global_position)
			wspeed = 1750
			await get_tree().create_timer(0.12).timeout
			wspeed = 0
			$anim.play("slash_durandal")
			$anim.queue("RESET")
			await get_tree().create_timer(0.2).timeout
			%aim.look_at(pl.global_position)
			targets = %aim/RolandDurandal/hitbox.get_overlapping_bodies()
			for targ in targets:
				if targ:
					if targ.has_method("t_dmg"):targ.t_dmg(8)
			await get_tree().create_timer(0.25).timeout
			targets = %aim/RolandDurandal/hitbox.get_overlapping_bodies()
			for targ in targets:
				if targ:
					if targ.has_method("t_dmg"):targ.t_dmg(8)
		$CollisionShape2D.disabled = false
		%aim/RolandDurandal.visible = false
	pass
#=========================================================
var light = 10

var cards = {"crystal":["crystal", 1],"atelier":["atellier", 2],"wheels":["wheels", 4],
"mspark":["furioso", 4], "ranga":["ranga",2], "durandal":["duran",3]}
var ckeys = []
var ccards = {}
var hand = []
func card_removal(card):ccards.erase(card);ckeys.erase(card)
	
func reload():
	ccards.merge(cards)
	for card in ccards:ckeys.append(card)
	ckeys.shuffle()
	var max_roll = 5
	var cho;var se
	while hand.size() < 5:
		rounded.randomize()
		if ccards.size() == 0 or ccards.size() == 0:break
		if max_roll <= 0:se = str(ckeys[0])
		else:cho = rounded.randi()%max_roll
		se = str(ckeys[cho])
		
		if light >= ccards[se][1]: light -= ccards[se][1]
		else: max_roll-=1;card_removal(se);continue
		hand.append(ccards[se][0])
		max_roll-=1;card_removal(se)
	light = 10
#=========================================================

var skill = 0
func _on_reload_timeout():
	%reload.wait_time = 1.5
	reload()
	for c in hand:
		var calla = Callable(self, c)
		if dead == false:
			await calla.call()
	if dead == false:dash()
	light = 8;hand.clear();ckeys.clear()
	#if skill == 1 and dead == false:crystal();if dead == false:dash()
	#elif skill == 2 and dead == false:atellier();if dead == false:dash()
	#elif skill == 3 and dead == false:wheels();if dead == false:dash()
	#elif skill == 4 and dead == false:blaster();if dead == false:dash()
	#else:
		#print("Random number was higher than moveset")
		#dash()

var bygones = 4
var phase35 = false
func memories():
	game.spawn_mob("bsfight/roland_bygone", 0, 1)
func less_bygones():
	bygones -= 1
	if bygones == 0:
		dead = false
		$gone_angels.volume_db = 1.25
		%hpbar.visible = true
		%reload.wait_time = 0.7
		%reload.paused = false
		%reload.start()
	elif bygones == 3:game.spawn_mob("bsfight/roland_bygone", 0, 2)
	elif bygones == 2:game.spawn_mob("bsfight/roland_bygone", 1, 2)

func t_dmg(edmg):
	if dead == false:
		hp -= edmg
		u_hp()
		play_hurt()
		
		if hp <= 200 and phase35 == false:
			phase35 = true
			dead = true
			%hpbar.visible = false
			hp = 400
			dmg = 4
			%reload.wait_time = 0.25
			wspeed = 0;atk=false;atk2=false
			%reload.paused = true
			memories()
		
	if hp <= 0 and dead == false:
		dead = true
		%hpbar.visible = false
		wspeed = 0;atk=false;atk2=false
		$gone_angels.stream_paused = true
		if Global.get_fused()==true:mainsong.play()
		else:if mainsong: mainsong.stream_paused = false
		#%aim/weapon.queue_free()
		pl.gain_g(69+int(mhp/2))
		%fade.play("win")
		%anim.play("RESET")
		%booked.play()
		%win.play("die")
		%reload.paused = true
		await get_tree().create_timer(6).timeout
		queue_free()
