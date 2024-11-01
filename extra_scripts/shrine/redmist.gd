extends Control

var skills = {
	"skill1":{"skill":"red_mist","name":"Carmen's Blessing","cost":10,"desc":"???"}}
var c_skill
var c_name
var c_cost
var c_desc

var style = StyleBoxFlat.new()
func upd_info():
	$info/s_name.text = c_name
	$info/s_cost.text = "Price: "+str(c_cost)+" Faith"
	$info/s_desc/desc.text = c_desc
	if Global.get_upg(c_skill) == true:
		$info/pray.text = "Blessed"
		style.bg_color = Color(1, 0.871, 0, 0.639)
		$info/pray.set("theme_override_styles/normal", style)
		$info/pray.disabled = true
	else:
		$info/pray.text = "Pray"
		style.bg_color = Color(0.6, 1, 0.6, 0.616)
		$info/pray.set("theme_override_styles/normal", style)
		$info/pray.disabled = false

func _process(_delta):
	
	if $brench1/skill1.button_pressed:
		var cs = skills.skill1
		c_skill = cs.skill
		c_name = cs.name
		c_cost = cs.cost
		c_desc = cs.desc
		upd_info()
#==============================
	if $info/pray.button_pressed and c_skill != null:
		$info/pray.button_pressed = false
		if Global.get_f() >= c_cost:
			Global.set_f(Global.get_f()-c_cost)
			Global.set_upg(c_skill, true)
			upd_info()
			get_parent().get_parent().refresh_f()
