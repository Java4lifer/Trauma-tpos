extends ProgressBar

#var test = {"Test":true}

@onready var timer:Timer = $tm
var timen
func set_time(wait_time):
	#timer.wait_time = wait_time
	timer.start(wait_time)
	max_value = wait_time
	value = wait_time
	timen = wait_time

func _process(delta):
	if !timer.is_stopped():
		value = timen-timer.time_left
