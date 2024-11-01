extends CharacterBody2D

signal no_hp
var hp = 100.0
var mhp = hp
func set_hp(nhp):hp = nhp;%hpbar.value = nhp;%hpbar/ahp.text = str(hp)+"/"+str(mhp)
func set_mhp(nhp):mhp = nhp;%hpbar.max_value = mhp;%hpbar/ahp.text = str(hp)+"/"+str(mhp)
func get_hp(x):
	if x==1:return hp
	if x==2: return mhp

@onready var cash = get_node("stats/cash")
func refresh_g(): cash.text = "Gold: "+str(Global.get_g())
func get_g(): return Global.get_g()
func gain_g(n):Global.gain_g(n);refresh_g()
func set_g(gold_n): Global.set_g(gold_n); refresh_g()
#==========================================================
@onready var wgivers = get_node("/root/MainFrame/wep_givers").get_children()
var swo
var gun
var wea = 'none'
func get_currentw():return wea
func set_gun(wep:Area2D, wep_t):
	if wep_t == 'gun':
		if %inv_gun.get_children().size() > 0:
			for giver in wgivers:
				if giver.get_child(giver.get_children().size()-1).get_props()[0]==%inv_gun.get_child(0).get_props()[0]:
					giver.set_bought(false)
				else:
					continue
			%inv_gun.remove_child(%inv_gun.get_child(0))
		%inv_gun.add_child(wep)
		gun = %inv_gun.get_child(0) 
		Global.store_gun(gun)
		gun.global_position = gun.get_parent().global_position
		if swo != null:
			swo.switch_v(false)
		gun.set_owned()
	if wep_t == 'swo':
		if %inv_swo.get_children().size() > 0:
			for giver in wgivers:
				if giver.get_child(giver.get_children().size()-1).get_props()[0]==%inv_swo.get_child(0).get_props()[0]:
					print("Weapon found, setting bought = false")
					giver.set_bought(false)
				else:
					print("Condition failed for "+giver.name)
			%inv_swo.remove_child(%inv_swo.get_child(0))
		%inv_swo.add_child(wep)
		swo = %inv_swo.get_child(0)
		Global.store_swo(swo)
		swo.global_position = swo.get_parent().global_position
		if gun:
			if gun.has_method("switch_v"):gun.switch_v(false)
		swo.set_owned()
func getter_gun(): if gun: return gun
func getter_swo(): if swo: return swo

func equip_gun():
	if swo:
		if swo.get_cds() == true:
			swo.switch_v(false)
			gun.switch_v(true)
	else:gun.switch_v(true)

func equip_swo():
	if stun == false:
		wea = 'swo'
	if gun:
		gun.switch_v(false)
		swo.switch_v(true)
	else:swo.switch_v(true)

#calculate physics, lets you move in games and stuff in general
@export var gui = false
var stun = false
var direction = null
var move = true
var dashcd = true
var max_speed = 850
var speed:int = max_speed
func get_speed(): return speed
func get_mspeed(): return max_speed
func set_speed(speedn):speed = speedn;
func set_mspeed(speedn):max_speed=speedn

func stun_p(time):
	if stun == true:
		%stun_timer.wait_time = time
		return
	speed = 0
	stun = true
	%stun_timer.wait_time = time
	%stun_timer.start()
	%stun.visible = true
func get_stun():return stun

const skb = preload("res://assets/skillbutton.tscn")

var skills_to_check = []
func check_skills():
	var is_here = false
	for ski in skills_to_check:
		if Global.get_upg(ski) == true:
			for instance in $stats/skill_bar.get_children():
				if instance.name == ski:is_here=true;break
				else:is_here=false
			if is_here == false:
				var skbi = skb.instantiate()
				skbi.get_node("key").text = Global.get_full_skill(ski).Key
				skbi.get_node("skill").text = Global.get_full_skill(ski).Name
				skbi.set_name(ski)
				$stats/skill_bar.add_child(skbi)

func _ready():
	skills_to_check.clear()
	for ski in Global.active_skills:
		skills_to_check.append(ski)
		print(ski)
	check_skills()
	
	#if Global.get_upg("MinorikoExtraHp"):set_mhp(get_hp(2)+25);set_hp(get_hp(1)+25)
	%hpbar/ahp.text = str(hp)+"/"+str(mhp)
	refresh_g()
func _process(_delta):
	refresh_g()
	#pass
func _physics_process(delta):
	if move == true:
		direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction*speed #in other words, (max_speed)px per second
	if Global.get_upg("SuwakoSpeedUp")==true:
		velocity = direction*(speed*1.3)
	move_and_slide()

	#var sprite = get_node("HappyBoo")
	#if velocity.length() > 0.0:
		#sprite.play_walk_animation()
	if stun == false and move == true:
		if get_global_mouse_position().x > global_position.x:
			if gun and gun.has_method("flip"): gun.flip(false)
			if swo and swo.has_method("flip"): swo.flip(false)
		else:
			if gun and gun.has_method("flip"): gun.flip(true)
			if swo and swo.has_method("flip"): swo.flip(true)

	#For heavy weapons with big cooldown, 
	#made get_cds and get_true_cds so that it doesn't take as long for the player to switch
	if Input.is_action_pressed("shoot") and gun and stun == false and gui==false:
		if swo:
			if swo.get_cds() == true:
				equip_gun()
				if stun == false:
					wea = 'gun'
					if gun.has_method("shoot"):gun.shoot()
		else:
			equip_gun()
			if stun == false:
				wea = 'gun'
				if gun.has_method("shoot"):gun.shoot()
	if Input.is_action_just_released("shoot"):wea = 'none'
	
	if Input.is_action_pressed("slash") and swo and wea != 'gun' and stun == false and gui==false:
		equip_swo()
		if stun == false:
			if swo.has_method("slash"):swo.slash()
		
	
	if Input.is_action_pressed("dash"):
		if stun == false:
			if dashcd == true and (velocity.length() != 0.0):
				if Global.get_upg("SuwakoDashCD")==true:%dtimer.wait_time = 0.6
				dashcd = false
				move = false
				speed = 3000
				await get_tree().create_timer(0.1).timeout
				speed = max_speed
				move = true
				%dtimer.start()
	#if Input.is_action_just_pressed("F"):
		#%car.look_at(wgivers[1].global_position)
		#direction = Vector2.from_angle(%car.rotation)
		#move = false
		##await get_tree().create_timer(0.1).timeout
		##await move_to_ayin()
		#while global_position > wgivers[1].global_position-Vector2(5, 5) and global_position < wgivers[1].global_position+Vector2(5, 5):
			#%car.look_at(wgivers[1].global_position)
			#direction = Vector2.from_angle(%car.rotation)
			#await get_tree().create_timer(delta).timeout
		#move = true
#func move_to_ayin():
	#await (global_position == wgivers[1].global_position)
	#print("So true")
	
func t_dmg(dmg):
	if stun == false:
		speed = max_speed
	move = true
	#dashcd = true
	if dmg > 0:
		if Global.get_sk("SuwakoSkill")==true:%hpbar/dodge.play("miss");return
		hp -= dmg
	%hpbar.value = hp;%hpbar/ahp.text = str(hp)+"/"+str(mhp)
	if hp <= 0.0:
		stun = false
		gun = null
		%inv_gun.remove_child(%inv_gun.get_child(0))
		%inv_swo.remove_child(%inv_swo.get_child(0))
		speed = max_speed
		move = true
		dashcd = true
		no_hp.emit()
		
func manual_dash(spd,rt,wt,tm):
	move = false
	direction = Vector2.from_angle(rt)
	speed = spd
	if wt == true:
		await get_tree().create_timer(tm).timeout
		speed = max_speed
		move = true
func dash_cancel():
	move = true
	speed = max_speed

func _on_dtimer_timeout():dashcd = true
func _on_stun_timer_timeout():stun = false;speed = max_speed;%stun.visible = false
