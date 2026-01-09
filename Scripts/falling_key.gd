extends Sprite2D

var fall_speed = 3
var init_x_pos: float = -360

func _init():
	set_process(false)

func _physics_process(delta: float) -> void:
	position -= Vector2(fall_speed, 0)

func Setup(target_y: float):
	global_position = Vector2(init_x_pos, target_y)
	set_process(true)
