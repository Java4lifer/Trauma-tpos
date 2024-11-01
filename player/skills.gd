extends Node2D
var pl
func _ready():
	pl = get_parent()
	pl.no_hp.connect(_on_player_no_hp)

var okinaskill=true;var minorikoskill=true;var suwakoskill=true
func _on_player_no_hp():
	okinaskill=true;minorikoskill=true;suwakoskill=true
	for ski in Global.active_skills:
		ski = false

var sup
func okina():
	for but in %stats.get_node("skill_bar").get_children():
		if but.name == "OkinaSkill":sup = but
	okinaskill = false
	Global.on_skill("OkinaSkill", true)
	sup.value = 0
	#else:print("Can't find the cooldown button")
	await get_tree().create_timer(10).timeout
	Global.on_skill("OkinaSkill", false)
	sup.set_time(20)
	await get_tree().create_timer(20).timeout
	okinaskill = true
func minoriko():
	minorikoskill = false
	Global.on_skill("MinorikoSkill", true)
	var regen = pl.get_hp(2)*0.05
	for i in range(20):
		pl.set_hp(pl.get_hp(1)+regen)
		if pl.get_hp(1)>pl.get_hp(2):pl.set_hp(pl.get_hp(2))
		await get_tree().create_timer(3).timeout
	Global.on_skill("MinorikoSkill", false)
	await get_tree().create_timer(30).timeout
	minorikoskill = true
func suwako():
	suwakoskill = false
	Global.on_skill("SuwakoSkill", true)
	await get_tree().create_timer(10).timeout
	Global.on_skill("SuwakoSkill", false)
	await get_tree().create_timer(20).timeout
	suwakoskill = true

func _process(_delta):
	if Input.is_action_just_pressed("Z") and Global.get_upg("OkinaSkill")==true and okinaskill != false:
		if get_parent().get_stun() == false:
			okina()
	if Input.is_action_just_pressed("X") and Global.get_upg("MinorikoSkill")==true and minorikoskill != false:
		if get_parent().get_stun() == false:
			minoriko()
	if Input.is_action_just_pressed("C") and Global.get_upg("SuwakoSkill")==true and suwakoskill != false:
		if get_parent().get_stun() == false:
			suwako()
		
