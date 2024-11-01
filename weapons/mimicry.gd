extends Area2D

func get_event():
	return "mimicry"

var owned = false
var cdstate = true
var cdn = 0.5
var price = "???"
var plr
var mainsong
func get_price(): return price
func get_props(): return ["Mimicry", %handle_mimicry.return_dmg(), cdn, price, 'swo']
func get_cd(): return cdn
func get_cds(): return cdstate
func set_owned(): 
	owned = true;plr = get_parent().get_parent();
	mainsong.stream = preload("res://audio/Red Mist.mp3");if mainsong.stream_paused==false:mainsong.play()
	if Global.buffed == false:
		plr.set_mhp(plr.get_hp(2)+100);plr.set_hp(plr.get_hp(2))
		Global.buffed = true
func switch_v(x):%Mimicry.visible = x
func flip(x): 
	%Mimicry.flip_v = x
	if x==false:swing=1
	else:swing=2

var swing = 1
var anim_speed = 1
func play_swing():
	if swing == 1:
		$anim.stop(true)
		$anim.play("slash_l",-1,anim_speed)
	else:
		$anim.stop(true)
		$anim.play("slash_r",-1,anim_speed)
	$anim.queue("RESET")

func _ready():
	$cdtimer.wait_time = cdn
	mainsong = get_node("/root/MainFrame/audioChannel1")

var atk = false
var targets = []
var ntarget = []
var split_inrange = []
var split_cdstate = true
var tracking = false
var splitting = false
func _process(_delta):
	if owned == true and tracking == false:
		%handle_mimicry.look_at(get_global_mouse_position())
	targets = %hitbox.get_overlapping_bodies()
	split_inrange = %split.get_overlapping_bodies()
	
	if atk==true:
		for target in targets:
			if target and target not in ntarget:
				ntarget.append(target)
				if plr.get_hp(1) > 0:
					if plr.get_hp(1) > 0:
						if target.has_method("t_dmg"):target.t_dmg(%handle_mimicry.return_dmg())
	
	if tracking == true and split_inrange.size()>0:
		%handle_mimicry.look_at(split_inrange.front().global_position)
		plr.manual_dash(2000,%handle_mimicry.rotation, false, 0)
		#if %Mimicry.global_position > global_position:flip(false)
		#else:flip(true)
	
	if Input.is_action_just_pressed("F") and split_cdstate == true and split_inrange.size()>0 and owned == true:
		#%split_limit.start()
		if plr and plr.get_stun() == false:
			cdstate = false
			$cdtimer.stop()
			if plr: plr.equip_swo()
			%split_timer.start()
			split_cdstate = false
			tracking = true
			splitting = true
			%hitbox.monitoring = false
			%hitbox.monitoring = true
			await get_tree().create_timer(2).timeout
			if splitting == true:
				%split_limit.start()
			

var buf = false
func slash():
	if cdstate == true:
		if Global.get_upg("OkinaAttackSpeedUp")==true and buf==false:$cdtimer.wait_time = cdn-(cdn*0.2);anim_speed +=0.2;buf=true
		$cdtimer.start()
		cdstate = false
		ntarget.clear()
		play_swing()
		await get_tree().create_timer(0.05).timeout
		atk = true
		await get_tree().create_timer(0.4).timeout
		atk = false

func _on_cdtimer_timeout():
	cdstate = true

func _on_split_timer_timeout():
	split_cdstate = true

func _on_split_limit_timeout():
	cdstate = true
	$cdtimer.start()
	plr.dash_cancel()
	tracking = false
	splitting = false
	await get_tree().create_timer(10).timeout
	split_cdstate = true

func _on_hitbox_body_entered(body):
	if splitting == true:
		cdstate = true
		$cdtimer.start()
		tracking = false
		splitting = false
		plr.dash_cancel()
		if body.has_method("t_dmg"):
			%canvas.visible = true
			%canvas/split.play()
			await %canvas/split.finished
			play_swing()
			body.t_dmg(%handle_mimicry.return_dmg()*17)
			%canvas.visible = false
		
		

