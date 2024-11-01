extends Marker2D

var dmg = 2

func check_forweapon():
	var ad = get_parent()
	if ad.name == "weaponP_grimoire": dmg=5
	if ad.name == "weaponP_machineg": dmg=1.5
	if name == "handle_longsword": dmg=4
	if name == "handle_mimicry": dmg=6

func _ready():
	check_forweapon()

func buffDamage(x):
	dmg += x

func calc_dmg(dm):
	var fdm = dm
	if Global.get_upg("okinaDamageUp") == true:fdm += dm*0.25
	if Global.get_upg("red_mist") == true:fdm += 2
	if Global.get_sk("OkinaSkill") == true:fdm *= 1.5
	return fdm
func return_dmg():
	check_forweapon()
	return calc_dmg(dmg)
