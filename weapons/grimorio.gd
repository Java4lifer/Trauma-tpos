extends Area2D

var owned = false
var cdstate = true
var cdn = 2
var price = 1500
func get_price(): return price
func get_props(): return ["Grimorio das Chamas", str(%bulspawn.return_dmg())+" + 20", cdn, price, 'gun']
func get_cd(): return cdn
func get_bullets():return %bulspawn.get_children()
func set_owned(): owned = true
func switch_v(x):%sprite_grimoire.visible = x
func get_cds(): return cdstate

func _ready():
	$guntimer.wait_time = cdn

func _process(_delta):
	if owned == true:
		look_at(get_global_mouse_position())

var buffed = false
func shoot():
	if Global.get_upg("OkinaAttackSpeedUp")==true and buffed == false:$guntimer.wait_time = cdn-(cdn*0.2);buffed=true
	if cdstate == true:
		cdstate = false
		const BUL = preload("res://weapons/fireball.tscn")
		var new_bul = BUL.instantiate()
		new_bul.global_position = %bulspawn.global_position
		#new_bul.position = %bulspawn.position
		new_bul.global_rotation = %bulspawn.global_rotation
		%bulspawn.add_child(new_bul)
		%channel2.play()
		$guntimer.start()

func _on_guntimer_timeout():
	cdstate = true
