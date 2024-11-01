extends Area2D

#gun MUST have these functions
var owned = false
var cdstate = true
var cdn = 0.6
var price = 0
func get_price(): return price
func get_props(): return ["Pistola", %bulspawn.return_dmg(), cdn, price, 'gun']
func get_cd(): return cdn
func get_cds(): return cdstate
func flip(bol):%Pistol.flip_v = bol
func get_bullets():return %bulspawn.get_children()
func set_owned(): owned = true
func switch_v(x):%Pistol.visible = x

func _ready():
	$guntimer.wait_time = cdn

func _process(_delta):
	if owned == true:
		look_at(get_global_mouse_position())
	if %Pistol.flip_v == true:
		%bulspawn.position.y = 0.8
	else:
		%bulspawn.position.y = -0.8

var rounded = RandomNumberGenerator.new()

var buffed = false
func shoot():
	if Global.get_upg("OkinaAttackSpeedUp")==true and buffed == false:$guntimer.wait_time = cdn-(cdn*0.2);buffed=true
	rounded.randomize()
	var ntimer = rounded.randf_range(-0.05,0.05)
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

#Let's make an array of invisible bullets and fill them with all the bullets inside "bulspawn" using a for loop
#after that, the "shoot" function will take the last child (bullets[-1]) and do a few things:
	#activate the hitbox, make it visible, and start its movement by turning True the variable "moving"
#When the bullet is fired, set global_transform to the spawner and remove it from the array.
#When the bullet hit something, deactivate its hitbox and sprite, and send a signal
#the signal interacts with the gun and puts it back inside the end of the array;
