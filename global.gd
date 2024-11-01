extends Node
var pl = preload("res://player/pchar.tscn").instantiate()

var gold = 999
var faith = 100
var saved_g = gold
var saved_f = faith
func set_g(g):gold = g
func gain_g(g):
	var bonus = 0
	if upgrades["MinorikoCashDropUp"] == true:
		bonus += g*0.25
	gold += g+bonus
	
func get_g():return gold
func set_f(f):faith = f
func get_f():return faith

@export var upgrades = {"okinaDamageUp":false, "OkinaAttackSpeedUp":false,"OkinaSkill":{"State":true,"Key":"Z", "Name":"Power of The Backdoor"}, 
"MinorikoCashDropUp":false,"MinorikoExtraHp":false,"MinorikoSkill":{"State":false,"Key":"X", "Name":"Plentful Harvest"},
"SuwakoSpeedUp":false,"SuwakoDashCD":false,"SuwakoSkill":{"State":false,"Key":"C", "Name":"Instinct"}, "red_mist":false}
@export var active_skills = {"OkinaSkill":false, "MinorikoSkill":false, "SuwakoSkill":false}
var saved_upgrades = upgrades
func set_upg(upg, x):
	for ups in active_skills:
		if ups == upg:
			upgrades[upg].State = x
			return
	upgrades[upg] = x
func get_upg(upg): 
	for ups in active_skills:
		if ups == upg:
			return upgrades[upg].State
	if upgrades[upg]:return upgrades[upg]
func get_full_skill(upg):if upgrades[upg]:return upgrades[upg]

func on_skill(sk, bol):active_skills[sk] = bol
func get_sk(g):return active_skills[g]

#Global Variables--------------------------------------------------------
@export var buffed = false
#------------------------------------------------------------------------

var guni
var swoi
var cycle_n = 0
var currency = 0
var saved_data = false
func get_saved():return saved_data

var bsilence = 1
func set_bs(n):bsilence=n
func get_bs():return bsilence

#=====================================
var smile_fused = false
func get_fused(): return smile_fused
func set_fused(x): smile_fused = x
var corps = 0
func set_corps(x, y):
	if y == 2:return corps
	corps = x
#=====================================

func store_player(player:CharacterBody2D):
	saved_g = gold
	saved_f = faith
	saved_upgrades = upgrades
	pl = player.duplicate()
	var properties: Array = player.get_property_list()
	var script_properties: Array = []
	for prop in properties:
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE == PROPERTY_USAGE_SCRIPT_VARIABLE:
			script_properties.append(prop)
	for prop in script_properties:
		pl.set(prop.name, player[prop.name])
func get_player(): 
	gold = saved_g
	faith = saved_f
	upgrades = saved_upgrades
	return pl

func store_gun(gun:Area2D):
	guni = gun.duplicate()
	var properties: Array = gun.get_property_list()
	var script_properties: Array = []
	for prop in properties:
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE == PROPERTY_USAGE_SCRIPT_VARIABLE:
			script_properties.append(prop)
	for prop in script_properties:
		guni.set(prop.name, gun[prop.name])
func get_gun(): return guni
func store_swo(swo:Area2D):
	swoi = swo.duplicate()
	var properties: Array = swo.get_property_list()
	var script_properties: Array = []
	for prop in properties:
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE == PROPERTY_USAGE_SCRIPT_VARIABLE:
			script_properties.append(prop)
	for prop in script_properties:
		swoi.set(prop.name, swo[prop.name])
func get_swo(): return swoi

func store_stats(cycle):cycle_n = cycle;saved_data = true
func get_stats(): return cycle_n
