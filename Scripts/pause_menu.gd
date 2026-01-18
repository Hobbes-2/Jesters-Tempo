extends Node2D

var opened : bool = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		if opened == true:
			opened = false
		else:
			opened = true

	if opened == false:
		self.hide()
		GlobalVars.game_paused = false
	if opened == true:
		self.show()
		get_tree().paused = true
		GlobalVars.game_paused = true

func _on_quit_pressed() -> void:
	if opened:
		get_tree().quit()


func _on_back_pressed() -> void:
	opened = false
	get_tree().paused = false
	GlobalVars.game_paused = false
