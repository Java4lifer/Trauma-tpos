extends Control

var skills = {
	"skill1":{"skill":"SuwakoSpeedUp","name":"Run Speed Up (1)","cost":1,"desc":"Character speed raised by 30%."},
	"skill2":{"skill":"SuwakoDashCD","name":"Dash Down","cost":4,"desc":"Dash cooldown decrease to 0.6"},
	"skill3":{"skill":"SuwakoSkill","name":"Instinct","cost":5,"desc":"For 10 seconds, all incoming damage is nullified."}}
var c_skill
var c_name
var c_cost
var c_desc

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
