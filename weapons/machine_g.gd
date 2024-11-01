extends Area2D

var owned = false
var cdstate = true
var cdn = 0.15
var price = 500
func get_price(): return price
func get_props(): return ["Metralhadora", %bulspawn.return_dmg(), cdn, price, 'gun']
func get_cd(): return cdn
func flip(bol):%sprite_machinegun.flip_v = bol
func get_bullets():return %bulspawn.get_children()
func set_owned(): owned = true
func switch_v(x):%sprite_machinegun.visible = x
func get_cds(): return cdstate

func _ready():
	$guntimer.wait_time = cdn

func _process(_delta):
	if owned == true:
		look_at(get_global_mouse_position())
	if %sprite_machinegun.flip_v == true:
		%bulspawn.position.y = 0.8
	else:
		%bulspawn.position.y = -0.8
	#if Input.is_action_just_released("shoot"): %channel2.stop()

var rounded = RandomNumberGenerator.new()
var buffed = false
func shoot():
	if Global.get_upg("OkinaAttackSpeedUp")==true and buffed == false:$guntimer.wait_time = cdn-(cdn*0.2);buffed=true
	rounded.randomize()
	var ntimer = rounded.randf_range(-0.125,0.125)
	if cdstate == true:
		cdstate = false
		const BUL = preload("res://weapons/bullet.tscn")
		var new_bul = BUL.instantiate()
		new_bul.global_position = %bulspawn.global_position
		new_bul.global_rotation = %bulspawn.global_rotation+ntimer
		%bulspawn.add_child(new_bul)
		%channel2.play()
		$guntimer.start()

func _on_guntimer_timeout():
	cdstate = true
