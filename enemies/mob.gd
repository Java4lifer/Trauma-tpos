extends CharacterBody2D

var hp = 10
var mhp = hp
var speed: int = 300
func buff_hp(hpn):
	hp += hpn
	mhp += hpn
	u_hp()
var dmg = 10
var atk = false
func get_dmg(): return dmg
func get_hp(): return hp
func u_hp():
	%hpbar.max_value=mhp;%hpbar.value=hp
	%hpbar/ahp.text=str(hp)+"/"+str(mhp)

@onready var pl = get_node("/root/MainFrame/player")
#or, @onready var player = get_node(yada yada
func _ready():
	$Slime.play_walk()
	u_hp()
	

func _physics_process(_delta):
	var direction = global_position.direction_to(pl.global_position)
	velocity = direction * speed
	move_and_slide()
	var things = %attack_area.get_overlapping_bodies()
	if things.size() > 0:
		if atk == true: for player in things:
			if player == pl:
				atk = false
				$Slime.play_hit()
				player.t_dmg(dmg)
				$Timer.start()


func _on_timer_timeout():
	$Timer.wait_time = 1.8
	atk = true

func t_dmg(edmg):
	hp -= edmg
	$Slime.play_hurt()
	u_hp()
	if hp <= 0:
		pl.gain_g(7+int(mhp/2))
		queue_free()
		
func make_boss(bonus):
	u_hp()
	scale = Vector2(1.2,1.2)
	speed += bonus*5
	dmg = 15+bonus/2


#func _on_attack_area_body_entered(body):
	#print("There's a body here")
	#if body.has_method("t_dmg"):
		#print("Body has method T_DMG")
		#while body:
			#if atk == true:
				#atk = false
				#$Slime.play_hit()
				#body.t_dmg(dmg)
				#$Timer.start()
		#$Timer.stop()
