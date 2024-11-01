#func script_it(input):
	#var script = GDScript.new()
	#script.set_source_code("func eval():"+input)
	#script.reload()
	#var ref = ReferenceRect.new()
	#ref.reparent(get_parent())
	#ref.set_script(script)
	#ref.eval()
extends Control

var skills = {
	"skill1":{"skill":"MinorikoCashDropUp","name":"Gold Drop Up (1)","cost":3,"desc":"Enemies drop 25% more gold."},
	"skill2":{"skill":"MinorikoExtraHp","name":"Maximum HP Up (1)","cost":2,"desc":"Grants the player an increase in HP of 25."},
	"skill3":{"skill":"MinorikoSkill","name":"Harvest Time","cost":5,"desc":"The player will start passively regenerating 5% of the max health every 3 seconds for 60 seconds."}}
var c_skill
var c_name
var c_cost
var c_desc

var direct_interaction

var style = StyleBoxFlat.new()
func upd_info():
	$info/s_name.text = c_name
	$info/s_cost.text = "Price: "+str(c_cost)+" Faith"
	$info/s_desc/desc.text = c_desc
	if c_skill!=null:if Global.get_upg(c_skill) == true:
		$info/pray.text = "Blessed"
		style.bg_color = Color(1, 0.871, 0, 0.639)
		$info/pray.set("theme_override_styles/normal", style)
		$info/pray.disabled = true
	else:
		$info/pray.text = "Pray"
		style.bg_color = Color(0.6, 1, 0.6, 0.616)
		$info/pray.set("theme_override_styles/normal", style)
		$info/pray.disabled = false

var brench
var brenches = ["brench1"]
var progress = {"brench1":0}

func _process(_delta):
	
	if $brench1/skill1.button_pressed:
		var cs = skills.skill1
		c_skill = cs.skill
		c_name = cs.name
		c_cost = cs.cost
		c_desc = cs.desc
		brench = 0
		direct_interaction = null
		upd_info()
	if $brench1/skill2.button_pressed:
		var cs = skills.skill2
		c_skill = null
		if progress["brench1"]>=1:
			c_skill = cs.skill
		c_name = cs.name
		c_cost = cs.cost
		c_desc = cs.desc
		brench = 0
		direct_interaction = "minorikohp1"
		upd_info()
	if $brench1/skill3.button_pressed:
		var cs = skills.skill3
		c_skill = null
		if progress["brench1"]>=2:
			c_skill = cs.skill
		c_name = cs.name
		c_cost = cs.cost
		c_desc = cs.desc
		brench = 0
		direct_interaction = null
		upd_info()
#==============================
	if $info/pray.button_pressed:
		$info/pray.button_pressed = false
		if c_skill != null:
			if Global.get_f() >= c_cost:
				Global.set_f(Global.get_f()-c_cost)
				Global.set_upg(c_skill, true)
				upd_info()
				get_parent().get_parent().refresh_f()
				progress[brenches[brench]] += 1
				#get_parent().get_parent().get_pl().get_script()._ready()
				if direct_interaction != null:
					get_parent().get_parent().exec_upg(direct_interaction)
					direct_interaction = null
