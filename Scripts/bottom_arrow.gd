extends Node2D

@onready var timing_area: Area2D = $TimingArea

var entered = false
var hit = false
var timeStop
var timer
@onready var player_controller: Node2D = $".."

var current_note 

var quips = ["Too early!", "Perfect!", "Nice!", "Close call!"]
var quip
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_controller.connect("downClick", hitInTime)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if hit == true:
		timeStop = 10.0 - timer.time_left
		if timeStop <= 0.1:
			quip = quips[0]
		elif timeStop >= 0.1 and timeStop <= 0.2:
			quip = quips[1]
		elif timeStop > 0.2 and timeStop <= 0.3 :
			quip = quips[2]
		print("Timing is " , timeStop, ". ", quip)
		current_note.queue_free()


func _on_timing_area_area_entered(area: Area2D) -> void:
	entered = true
	current_note = area.get_parent()
	timer = get_tree().create_timer(10.0)


func _on_timing_area_area_exited(area: Area2D) -> void:
	entered = false
	if hit == false:
		print("Missed a note!")

	hit = false


func hitInTime():
	hit = true
