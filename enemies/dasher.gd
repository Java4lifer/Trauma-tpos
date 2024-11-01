extends CharacterBody2D

func play_walk():
	%AnimationPlayer.play("walk")


func play_hurt():
	%AnimationPlayer.play("hurt")
	%AnimationPlayer.queue("walk")
	
func play_hit():
	%AnimationPlayer.play("attack")
	%AnimationPlayer.queue("walk")

var hp = 16
var mhp = hp
func buff_hp(hpn):
	hp += hpn
	mhp += hpn
	u_hp()
var wspeed = 300
var dmg = 20
var atk = false
func get_dmg(): return dmg
func get_hp(): return hp
func u_hp():
	%hpbar.max_value=mhp;%hpbar.value=hp
	%hpbar/ahp.text=str(hp)+"/"+str(mhp)

var pl 
#or, @onready var player = get_node(yada yada
func _ready():
	pl = get_node("/root/MainFrame/player")
	play_walk()
	u_hp()

var homing = true
var direction
func _physics_process(_delta):
	if homing == true:
		direction = global_position.direction_to(pl.global_position)
	velocity = direction * wspeed
	move_and_slide()
	
	var things = %attack_area.get_overlapping_bodies()
	if things.size() > 0:
		if atk == true: for player in things:
			if player == pl:
				atk = false
				play_hit()
				player.t_dmg(dmg)
				$Timer2.start()
		
		
func _on_timer_timeout():
	#wspeed = 4000
	#await get_tree().create_timer(0.1).timeout
	homing = false
	%aim.look_at(pl.global_position)
	direction = Vector2.from_angle(%aim.rotation)
	wspeed = 2000
	await get_tree().create_timer(0.16).timeout
	homing = true
	wspeed = 300

func t_dmg(edmg):
	hp -= edmg
	u_hp()
	play_hurt()
	if hp <= 0:
		pl.gain_g(8+int(mhp/2))
		queue_free()


func _on_timer_2_timeout():
	$Timer2.wait_time = 1.2	
	atk = true

func make_boss(bonus):
	wspeed += bonus*8
	dmg = 10+bonus
	if bonus/10 > 0.7:
		$Timer.wait_time = 0.8
	else:
		$Timer.wait_time = 1.5-(bonus/10)
