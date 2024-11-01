extends Camera2D

var noffset = Vector2(0,0)

@export var rstrength = 30
func set_rstrength(a):rstrength = a
@export var shake_fade = 0
func set_shake_fade(a):shake_fade = a

var rng = RandomNumberGenerator.new()
var shake_strength:float = 0

func apply_shake():
	shake_strength = rstrength

func rand_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

func reset():
	offset = noffset

func _process(delta):
	if shake_strength >0:
		shake_strength = lerpf(shake_strength, 0, shake_fade*delta)
		offset = rand_offset()
	if shake_strength<=0:
		reset()

func _physics_process(_delta):
	pass
