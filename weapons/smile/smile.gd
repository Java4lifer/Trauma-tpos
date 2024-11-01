extends Area2D

var owned = false
var player:CharacterBody2D
var playercam
func set_owned():
	owned=true;
	player = get_parent().get_parent();playercam = player.get_child(0);
	bodies = Global.set_corps(0,2);bodies_t.text = "Corpses: "+str(bodies);
	%body_count.visible = true
func flip(x):
	if stuck == true:return
	%smiler.flip_v=x
	if x==true:swing = 2
	else:swing = 1
var cdstate = true
var dmg = 2
var bodies = 0
var bonus = 1
@onready var bodies_t = get_node("CanvasLayer/body_count")
func get_cds(): return cdstate

var cdn = 0.7
var price = 300
func get_price(): return price
func get_props(): return ["Smile", dmg, cdn, price, 'swo']
func switch_v(x):%smiler.visible = x

var mainsong
func _ready():
	if Global.get_fused() == false:
		#$warning.stream_paused == true
		%warning_img.visible = false
	bodies = Global.set_corps(0,2)
	bodies_t.text = "Corpses: "+str(bodies);
	mainsong = get_node("/root/MainFrame/audioChannel1")
	

var swing = 1
var anim_speed = 1
func play_swing():
	if swing == 1:
		$animator.stop(true)
		$animator.play("swing_l",-1,anim_speed)
	else:
		$animator.stop(true)
		$animator.play("swing_r",-1,anim_speed)
	$animator.queue("RESET")
	$swing_timer.wait_time = 0.7
	$swing_timer.start()
  #if swing == 1:
	#$animator.play("swing_l")
	#$swing_timer.start(2)
	#swing = 2
  #if swing == 2:
	#$animator.play("swing_r")
	#$swing_timer.start(2)
	#swing = 1
func eat(target):
	if target.has_method("get_hp"):
		if target.get_hp() <= dmg:
			$eating.play()
			bodies +=1;
			Global.set_corps(bodies,1)
			bodies_t.text = "Corpses: "+str(bodies);
			if player.get_hp(2)<=500 and Global.get_fused()==true:
				player.set_mhp(player.get_hp(2)+5+bonus)
				if player.get_hp(2) > 500:
					player.set_mhp(500)
			player.set_hp(player.get_hp(1)+target.get_hp()+bonus);
			if player.get_hp(1) > 500:
				player.set_hp(500)
			if player.get_hp(1) > player.get_hp(2):player.set_hp(player.get_hp(2))
			if Global.get_fused()==true:
				dmg=2+int(bodies/5)

var buf = false
func slash():
	if cdstate == true:
		if Global.get_upg("OkinaAttackSpeedUp")==true and buf==false:$cdTime.wait_time = cdn-(cdn*0.2);anim_speed +=0.2;buf=true
		$cdTime.start()
		cdstate = false
		ntarget.clear()
		play_swing()
		await get_tree().create_timer(0.1).timeout
		atk = true
		await get_tree().create_timer(0.4).timeout
		atk = false

var atk = false
var roar_cd = false
var roar = false
var targets = []
var ntarget = []
var rtargets=[]
var stuck = false
func _process(delta):
	if player and player.get_hp(1) <= 0: targets.clear()
	if player and player.get_hp(1) > 0:
		targets = %hitbox.get_overlapping_bodies()
		if atk == true:
			for target in targets:
				if target and target not in ntarget:
					ntarget.append(target)
					if target.has_method("t_dmg") and player:
						if player.get_hp(1)>0:
							eat(target)
							target.t_dmg(dmg)
		
	rtargets = %roarea.get_overlapping_bodies()
	if roar == true:
		for target in rtargets:
			if target.has_method("t_dmg"):target.t_dmg(dmg*delta)
	
	if owned == true and stuck == false:
		%handle_smile.look_at(get_global_mouse_position())
	if stuck == true:
		%handle_smile.rotation = 0
	
	if bodies >= 10:
		bonus = int(bodies/10)
	if Input.is_action_just_pressed("F") and bodies >= 10 and Global.get_fused() == false and owned == true and player.get_currentw() != 'gun':
		player.equip_swo()
		Global.set_fused(true)
		dmg = 10
		mainsong.stream = preload("res://audio/Too Many Trumpets - Item Asylum.mp3")
		if mainsong.stream_paused == false:mainsong.play()
		%warning_img.visible = true
		%canvanim.play("warning")
		var nhp = 100+bodies*5
		if nhp>500:nhp=500
		player.set_hp(9999)
		player.stun_p(2.85)
		$scream.play()
		if playercam:
			playercam.set_shake_fade(0)
			playercam.set_rstrength(10)
			playercam.apply_shake()
		stuck = true
		%handle_smile.rotation = 0
		%smiler.flip_v = false
		$animator.play("roar")
		roar = true
		await $scream.finished
		if playercam:
			playercam.set_shake_fade(5)
		#2.83 seconds
		roar = false
		$animator.play("RESET")
		stuck = false
		player.set_hp(nhp)
		player.set_mhp(nhp)
		dmg=2+int(bodies/5)
		$roar_time.start()
		
	if Input.is_action_just_pressed("F")and roar_cd==true and bodies >= 10 and Global.get_fused() == true and owned == true and player.get_currentw() != 'gun':
		if player and player.get_stun() == true:return
		player.equip_swo()
		roar_cd=false
		var temp_hp = player.get_hp(1)
		player.set_hp(9999)
		player.stun_p(2.85)
		$scream.play()
		stuck = true
		%handle_smile.rotation = 0
		%smiler.flip_v = false
		$animator.play("roar")
		#var playercam = player.get_child(0)
		if playercam:
			playercam.set_shake_fade(0)
			playercam.set_rstrength(10)
			playercam.apply_shake()
		roar = true
		await $scream.finished
		if playercam:
			playercam.set_shake_fade(5)
		roar = false
		$animator.play("RESET")
		stuck = false
		player.set_hp(temp_hp)
		$roar_time.start()


func _on_swing_timer_timeout():
	#swing = 1
	#$animator.play("RESET")
	pass

func _on_cd_time_timeout():
	cdstate = true

func _on_roar_time_timeout():
	roar_cd = true
