extends Area2D

var owned = false
var cdstate = true
var cdn = 0.5
var price = 0
func get_price(): return price
func get_props(): return ["Espada longa", %handle_longsword.return_dmg(), cdn, price, 'swo']
func get_cd(): return cdn
func get_cds(): return cdstate
func set_owned(): owned = true
func switch_v(x):%RolandDurandal.visible = x

func _ready():
	$cdtimer.wait_time = cdn

var sw = 0
var anim_speed = 1
func swing():
	if sw==0:
		$anim.play("slash_1",-1,anim_speed)
		sw=1
	elif sw==1:
		$anim.play("slash_2",-1,anim_speed)
		sw=2
	elif sw==2:
		$anim.play("slash_3",-1,anim_speed)
		sw=1
	await $anim.animation_finished
	$stimer.start()

var targets = []
var ntarget = []
var atk = false
func _process(_delta):
	if owned == true:
		look_at(get_global_mouse_position())
	if atk == true:
		targets = %hitbox.get_overlapping_bodies()
		if targets.size() > 0:
			for target in targets:
				if target not in ntarget:
					ntarget.append(target)
					if target.has_method("t_dmg"):target.t_dmg(%handle_longsword.return_dmg())
				else: continue
	#split_inrange = get_overlapping_bodies()

var buf = false
func slash():
	if cdstate == true:
		if Global.get_upg("OkinaAttackSpeedUp")==true and buf==false:$cdtimer.wait_time = cdn-(cdn*0.2);anim_speed +=0.2;buf=true;
		$cdtimer.start()
		cdstate = false
		ntarget.clear()
		swing()
		if not get_tree():return
		await get_tree().create_timer(0.08).timeout
		atk = true
		if not get_tree():return
		await get_tree().create_timer(0.34).timeout
		atk = false

func _on_cdtimer_timeout():
	cdstate = true


func _on_stimer_timeout():
	$anim.queue("rest")
	sw = 0
