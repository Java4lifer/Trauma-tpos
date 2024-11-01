extends CanvasLayer

@onready var sc = get_node("selection_gui")
@onready var ss = get_node("skills_gui")

var pl
func set_pl(a):pl = a
func get_pl():if pl:return pl

func refresh_f():
	%faith.text = "Faith: "+str(Global.get_f())
	%faith2.text = "Faith: "+str(Global.get_f())

func _process(_delta):
	if $selection_gui/close.button_pressed:
		sc.visible = false
		%instruction.visible = true
	if $skills_gui/close.button_pressed:
		for thing in $skills_gui.get_children():
			if thing.get_class() == "Control" and thing.visible == true:
				thing.visible = false
		$skills_gui.visible = false
		$selection_gui.visible = true
#=================================================
	if $selection_gui/ex_button.button_pressed:
		$selection_gui/ex_button.button_pressed = false
		if Global.get_g() >= 100:
			Global.set_g(Global.get_g()-100)
			Global.set_f(Global.get_f()+1)
			if pl:pl.refresh_g()
			refresh_f()
#=================================================
	if %god_list/okina.button_pressed:
		sc.visible = false
		ss.visible = true
		%okina.visible = true
	if %god_list/minoriko.button_pressed:
		sc.visible = false
		ss.visible = true
		%minoriko.visible = true
	if %god_list/suwako.button_pressed:
		sc.visible = false
		ss.visible = true
		%suwako.visible = true
	if %god_list/carmen.button_pressed:
		sc.visible = false
		ss.visible = true
		%redmist.visible = true

func exec_upg(upg):
	if upg == "minorikohp1":pl.set_mhp(pl.get_hp(2)+25);pl.set_hp(pl.get_hp(1)+25)

func _on_selection_gui_visibility_changed():
	if $selection_gui.visible == true:
		refresh_f()

func _on_skills_gui_visibility_changed():
	if $skills_gui.visible == true:
		refresh_f()
