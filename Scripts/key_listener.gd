extends Node2D

@export var direction : String = ""
@export var song : AudioStreamMP3
@export var debug : bool = false
@export var part : AudioStreamMP3
@export var partName : String = ""
@export var BPM : float = 145.0


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

var spectrum
var pitch
var output : Array = []

var timeSignature : float = 60 / BPM
var next_beat_time := 0.0

var currentBeat = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#OS.execute(
	#"bash",
	#["-c", "source venv/bin/activate && demucs song.mp3"],
	#output
#)
	song_player_calc.bus = partName
	song_player_calc.stream = part
	song_player_calc.playing = true
	await get_tree().create_timer(1.92).timeout
	song_player.stream = song
	song_player.playing = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	print(currentBeat)

	if GlobalVars.game_paused == true:
		song_player_calc.stream_paused = true
		song_player.stream_paused = true
	else:
		song_player_calc.stream_paused = false
		song_player.stream_paused = false

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


##Put a if statement in here to check if the part is and adjust the -80 accordingly
	#if AudioServer.get_bus_peak_volume_left_db(AudioServer.get_bus_index(partName), 0) < -80:
		#CreateFallingKey()
		#await get_tree().create_timer(0.5).timeout
#
	#print(AudioServer.get_bus_peak_volume_left_db(AudioServer.get_bus_index(partName), 0))

##With overall sound
	#if AudioServer.get_bus_peak_volume_right_db(1, 0) > -75.0:
		#CreateFallingKey()
		#print(AudioServer.get_bus_peak_volume_right_db(1, 0))

##This is with pitch
	#var magnitude = spectrum.get_magnitude_for_frequency_range(20, 20000)
	#pitch = magnitude.length()
	#print("Pitch is: ", pitch)
	#if pitch >= 0.4:
		#CreateFallingKey()


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


	#if !song_player_calc.playing:
		#return

	var song_time = song_player_calc.get_playback_position()
	print(song_time)
	#if roundf(song_time) >= next_beat_time:
		#CreateFallingKey()
		#next_beat_time += timeSignature
##Another way

	#if $TempTimer.time_left <= 0.0:
		#if AudioServer.get_bus_peak_volume_right_db(AudioServer.get_bus_index(partName), 0) > -15.0:
			#CreateFallingKey()
			#print(AudioServer.get_bus_peak_volume_right_db(AudioServer.get_bus_index(partName), 0))
		#$TempTimer.start()

	if roundf(song_time) >= next_beat_time:
		next_beat_time += timeSignature
		if AudioServer.get_bus_peak_volume_right_db(AudioServer.get_bus_index(partName), 0) > -15.0:
			CreateFallingKey()
			print(AudioServer.get_bus_peak_volume_right_db(AudioServer.get_bus_index(partName), 0))
		$TempTimer.start()

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

#var last_energy := 0.0
#const ONSET_THRESHOLD := 0.12
#
#func detect_onset(current_energy):
	#var delta = current_energy - last_energy
	#last_energy = current_energy
	#return delta > ONSET_THRESHOLD
#
#const MIN_INTERVAL := 0.18 # ~1/8 note at 120 BPM
#var last_spawn_time := -999.0
#
#func can_spawn(song_time):
	#return song_time - last_spawn_time > MIN_INTERVAL
