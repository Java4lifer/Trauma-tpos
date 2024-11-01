extends CharacterBody2D

var boss = false
var hp = 12
var mhp = hp
func buff_hp(hpn):
	hp += hpn
	mhp += hpn
	u_hp()
func get_hp(): return hp
func u_hp():
	%hpbar.max_value=mhp;%hpbar.value=hp
	%hpbar/ahp.text=str(hp)+"/"+str(mhp)

@onready var pl = get_node("/root/MainFrame/player")
#or, @onready var player = get_node(yada yada
func _ready():
	u_hp()
func _physics_process(_delta):
	$shootingrange.look_at(pl.global_position)

var random = true
var rounded = RandomNumberGenerator.new()
func _on_timer_timeout():
	if random:
		rounded.randomize()
		var ntimer = rounded.randf_range(0.8,1.5)
		$Timer.wait_time = ntimer
	if boss:$Timer.wait_time = 0.5
	const BUL = preload("res://weapons/enemy_attacks/ebullet_1.tscn")
	var new_bul = BUL.instantiate()
	new_bul.global_position = %bulspawn.global_position
	new_bul.global_rotation = %bulspawn.global_rotation
	%AnimationPlayer.play("attack")
	%AnimationPlayer.queue("RESET")
	%bulspawn.add_child(new_bul)
	$Timer.start()

func t_dmg(edmg):
	hp -= edmg
	u_hp()
	%AnimationPlayer.play("hurt")
	if hp <= 0:
		pl.gain_g(8+int(mhp/2))
		queue_free()

func make_boss(bonus):
	boss = true
	random = false
	%bulspawn.set_dmg(15+bonus)
