#extends Node
#
##Arvore
#var hp = 10
#var mhp = hp
#func get_hp(): return hp
#func t_dmg(edmg):
	#hp -= edmg
	#if hp <= 0:
		#var a = preload("res://assets/baa.jpg").instantialize()
		#a.global_position = self.global_position
		#get_parent().add_child(a)
		#queue_free()
#
##Jogador
#@onready var gun #= path to weapon
#func _physics_process(_delta):
	#if Input.is_action_just_pressed("shoot"):
		#if gun and gun.has_method("fire"): gun.fire()
#
##Arma==========================================================================
#var cdstate = true
#var cdn = 0.6
#func _ready():
	#$guntimer.wait_time = cdn
#
#var targets = []
#var ntarget = []
#var atk = false
#func _process(_delta):
	##look_at(get_global_mouse_position())
	#if atk == true:
		#targets = %hitbox.get_overlapping_bodies()
		#if targets.size() > 0:
			#for target in targets:
				#if target not in ntarget:
					#ntarget.append(target)
					#if target.has_method("t_dmg"):target.t_dmg(%handle_longsword.return_dmg())
				#else: continue
#func slash():
	#if cdstate == true:
		#$cdtimer.start()
		#cdstate = false
		#ntarget.clear()
		##if not get_tree():return
		#atk = true
		##if not get_tree():return
		#await get_tree().create_timer(0.4).timeout
		#atk = false
#
#func _on_cdtimer_timeout():
	#cdstate = true
