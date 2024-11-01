extends Area2D

@onready var status = %status
@onready var nome = %nome

var inrange = false
var bought = false
var pl:CharacterBody2D
var weapon
func get_wepper(): if weapon: return weapon
func set_bought(bol):
	if bol == true:
		if weapon: weapon.visible = false
		bought = true
		$instruction.visible = false
	else:
		if weapon: weapon.visible = true
		bought = false
		
var weapon_t
func _ready():
	if get_children().size() > 5:
		#print("Weapon detected ", get_children().size())
		weapon = get_child(get_children().size()-1)
		weapon.global_position = %store.global_position
	else:
		print("Weapon does not count")
	if weapon:
		var sta = weapon.get_props()
		nome.text = sta[0]
		status.text = "Dano: "+str(sta[1])+"\nRecarga: "+str(sta[2])+"s\nPreço: "+str(sta[3])+" gold"
		weapon_t = sta[4]

func _process(_delta):
	if Input.is_action_just_pressed("E") and inrange == true and bought == false:
		if weapon.has_method("get_event"):
			
			if weapon.get_event() == "mimicry":
				if Global.get_upg("red_mist") == true:
					pl.set_gun(weapon.duplicate(), weapon_t)
					weapon.visible = false
					bought = true
					
		else:
			var price = weapon.get_price();var pgold = pl.get_g()
			if pgold >= price:
				pl.set_g(pgold-price)
				pl.set_gun(weapon.duplicate(), weapon_t)
				weapon.visible = false
				bought = true

func _on_body_entered(body):
	pl = body
	if bought == false:
		$instruction.visible = true
		%propas.visible = true
	inrange = true


func _on_body_exited(_body):
	$instruction.visible = false
	%propas.visible = false
	inrange = false
