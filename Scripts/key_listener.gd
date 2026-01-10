extends Node2D

@export var direction : String = ""
@export var song : AudioStreamMP3
@export var debug : bool = false

#@onready var score_text = preload("res://objects/score_press_text.tscn")
@onready var falling_key = preload("res://Scenes/falling_key.tscn")
@onready var timing_area: Area2D = $TimingArea
@onready var player_controller: Node2D = $".."
@onready var song_player: AudioStreamPlayer = $SongPlayer
@onready var song_player_calc: AudioStreamPlayer = $SongPlayerCalc

var entered = false
var hit = false
var timeStop
var timer

var current_note
var falling_key_queue : Array = []

var quips = ["Too early!", "Perfect!", "Nice!", "Close call!"]
var quip

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	song_player_calc.stream = song
	song_player_calc.playing = true
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Calculator"), true)
	await get_tree().create_timer(1.92).timeout
	song_player.stream = song
	song_player.playing = true

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
		if debug:
			print("Timing is " , timeStop, ". ", quip)
		current_note.queue_free()

	if AudioServer.get_bus_peak_volume_right_db(1, 0) > -75.0:
		CreateFallingKey()
		print(AudioServer.get_bus_peak_volume_right_db(1, 0))

	if Input.is_action_just_pressed(direction.capitalize()):
		if entered == true:
			if debug:
				print(direction, " hit!")
			hitInTime()
		else:
			if debug:
				print(direction, " missed!")
	if !falling_key_queue.is_empty():
		if falling_key_queue[0].global_position.x < global_position.x - 20:
			falling_key_queue.pop_front()
			if debug:
				print(falling_key_queue)

func _on_timing_area_area_entered(area: Area2D) -> void:
	entered = true
	current_note = area.get_parent()
	timer = get_tree().create_timer(10.0)


func _on_timing_area_area_exited(area: Area2D) -> void:
	entered = false
	if hit == false:
		if debug:
			print("Missed a note!")
	hit = false


func hitInTime():
	hit = true
	if !falling_key_queue.is_empty():
		falling_key_queue.pop_front().queue_free()

func CreateFallingKey():
	#if button_name == key_name:
		var fk_inst = falling_key.instantiate()
		fk_inst.animation = direction
		get_tree().get_root().call_deferred("add_child", fk_inst)
		fk_inst.Setup(position.y)
		
		falling_key_queue.push_back(fk_inst)


func _on_random_timer_timeout():
	#CreateFallingKey()
	$RandomTimer.wait_time = randf_range(0.4, 3)
	$RandomTimer.start()
