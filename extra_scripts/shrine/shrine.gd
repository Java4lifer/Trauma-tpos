extends Area2D

var inrange = false
var pl:CharacterBody2D

func _process(_delta):
	if Input.is_action_just_pressed("E") and inrange == true:
		if pl and pl.gui:pl.gui = true
		%guis/selection_gui.visible = true
		%instruction.visible = false
	pass

func _on_body_entered(body):
	pl = body
	inrange = true
	%instruction.visible = true
	%guis.set_pl(body)
	#pl = body

@onready var sc = get_node("guis/selection_gui")
func _on_body_exited(_body):
	if pl:
		pl.check_skills()
		if pl.gui:pl.gui = false;
	%instruction.visible = false
	inrange = false
	sc.visible = false
	for thing in $guis/skills_gui.get_children():
		if thing.get_class() == "Control" and thing.visible == true:
			thing.visible = false
	$guis/skills_gui.visible = false
