extends AnimatedSprite2D

var fall_speed = 3
#Starting x pos
var init_x_pos: float = 200
var has_passed: bool = false
var pass_threshold = -144.0

func _init():
	set_process(false)

func _physics_process(delta: float) -> void:
	position -= Vector2(fall_speed, 0)
	# Find out how long it takes for arrow to reach critical spot
	if global_position.x < pass_threshold and not $Timer.is_stopped():
		print("Time is:", $Timer.wait_time - $Timer.time_left)
		$Timer.stop()
		has_passed = true

func Setup(target_y: float):
	global_position = Vector2(init_x_pos, target_y)
	set_process(true)
