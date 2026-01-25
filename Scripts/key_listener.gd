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

#var entered = false
#var hit = false
#var timeStop
#var timer
#
#var current_note
#var falling_key_queue : Array = []
#
#var quips = ["Too early!", "Perfect!", "Nice!", "Close call!"]
#var quip
#
#var spectrum
#var pitch
#var output : Array = []
#
#var timeSignature : float = 60 / BPM
#var next_beat_time := 0.0
#
#var currentBeat = 0

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	##OS.execute(
	##"bash",
	##["-c", "source venv/bin/activate && demucs song.mp3"],
	##output
##)
	#song_player_calc.bus = partName
	#song_player_calc.stream = part
	#song_player_calc.playing = true
	#await get_tree().create_timer(1.92).timeout
	#song_player.stream = song
	#song_player.playing = true
#
	#print(part.get_data())
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta: float) -> void:
#
	#print(currentBeat)
#
	#if GlobalVars.game_paused == true:
		#song_player_calc.stream_paused = true
		#song_player.stream_paused = true
	#else:
		#song_player_calc.stream_paused = false
		#song_player.stream_paused = false
#
	#if hit == true:
		#timeStop = 10.0 - timer.time_left
		#if timeStop <= 0.1:
			#quip = quips[0]
		#elif timeStop >= 0.1 and timeStop <= 0.2:
			#quip = quips[1]
		#elif timeStop > 0.2 and timeStop <= 0.3 :
			#quip = quips[2]
		#if debug:
			#print("Timing is " , timeStop, ". ", quip)
		#current_note.queue_free()
#
#
###Put a if statement in here to check if the part is and adjust the -80 accordingly
	##if AudioServer.get_bus_peak_volume_left_db(AudioServer.get_bus_index(partName), 0) < -80:
		##CreateFallingKey()
		##await get_tree().create_timer(0.5).timeout
##
	##print(AudioServer.get_bus_peak_volume_left_db(AudioServer.get_bus_index(partName), 0))
#
###With overall sound
	##if AudioServer.get_bus_peak_volume_right_db(1, 0) > -75.0:
		##CreateFallingKey()
		##print(AudioServer.get_bus_peak_volume_right_db(1, 0))
#
###This is with pitch
	##var magnitude = spectrum.get_magnitude_for_frequency_range(20, 20000)
	##pitch = magnitude.length()
	##print("Pitch is: ", pitch)
	##if pitch >= 0.4:
		##CreateFallingKey()
#
#
	#if Input.is_action_just_pressed(direction.capitalize()):
		#if entered == true:
			#if debug:
				#print(direction, " hit!")
			#hitInTime()
		#else:
			#if debug:
				#print(direction, " missed!")
	#if !falling_key_queue.is_empty():
		#if falling_key_queue[0].global_position.x < global_position.x - 20:
			#falling_key_queue.pop_front()
			#if debug:
				#print(falling_key_queue)
#
#
	##if !song_player_calc.playing:
		##return
#
	#var song_time = song_player_calc.get_playback_position()
	#print(song_time)
	##if roundf(song_time) >= next_beat_time:
		##CreateFallingKey()
		##next_beat_time += timeSignature
###Another way
#
	##if $TempTimer.time_left <= 0.0:
		##if AudioServer.get_bus_peak_volume_right_db(AudioServer.get_bus_index(partName), 0) > -15.0:
			##CreateFallingKey()
			##print(AudioServer.get_bus_peak_volume_right_db(AudioServer.get_bus_index(partName), 0))
		##$TempTimer.start()
#
	#if roundf(song_time) >= next_beat_time:
		#next_beat_time += timeSignature
		#if AudioServer.get_bus_peak_volume_right_db(AudioServer.get_bus_index(partName), 0) > -15.0:
			#CreateFallingKey()
			#print(AudioServer.get_bus_peak_volume_right_db(AudioServer.get_bus_index(partName), 0))
		#$TempTimer.start()
#
#func _on_timing_area_area_entered(area: Area2D) -> void:
	#entered = true
	#current_note = area.get_parent()
	#timer = get_tree().create_timer(10.0)
#
#
#func _on_timing_area_area_exited(area: Area2D) -> void:
	#entered = false
	#if hit == false:
		#if debug:
			#print("Missed a note!")
	#hit = false
#
#func hitInTime():
	#hit = true
	#if !falling_key_queue.is_empty():
		#falling_key_queue.pop_front().queue_free()
#
#func CreateFallingKey():
	##if button_name == key_name:
		#var fk_inst = falling_key.instantiate()
		#fk_inst.animation = direction
		#get_tree().get_root().call_deferred("add_child", fk_inst)
		#fk_inst.Setup(position.y)
		#
		#falling_key_queue.push_back(fk_inst)
#
#
#func _on_random_timer_timeout():
	##CreateFallingKey()
	#$RandomTimer.wait_time = randf_range(0.4, 3)
	#$RandomTimer.start()
#
##var last_energy := 0.0
##const ONSET_THRESHOLD := 0.12
##
##func detect_onset(current_energy):
	##var delta = current_energy - last_energy
	##last_energy = current_energy
	##return delta > ONSET_THRESHOLD
##
##const MIN_INTERVAL := 0.18 # ~1/8 note at 120 BPM
##var last_spawn_time := -999.0
##
##func can_spawn(song_time):
	##return song_time - last_spawn_time > MIN_INTERVAL

var audio_stream : AudioStreamMP3
var sample_rate : int
var samples : PackedByteArray
var window_size : int = 1024  # Size of the window for FFT
var pitch_values : Array = []
var important_notes : Array = []

func _ready():
	# Load the MP3 and get its sample data
	audio_stream = load(part.resource_path) as AudioStreamMP3
	sample_rate = 48
	samples = audio_stream.get_data()

	# pre-analysis of the pitch
	track_pitch()

	# find important notes from pitch
	important_notes = find_important_notes()

	print(partName, "- Important note at:", important_notes)

# Track pitch over time
func track_pitch():
	# Checks the data in sizes of windwo size - maybe i gotta set this to bpm related smthin?
	for i in range(0, samples.size() - window_size, window_size):
		var window = samples.slice(i, i + window_size)

		# fourier it :hehe: to get the frequency spectrum
		var fft = samples# <- this should be the audio byte data but im tired and dont know how to get or store it
		fft.process(window)
		var spectrum = fft.get_spectrum()

		# Get the main pitch in the window checked
		var max_amplitude = -1.0
		var max_frequency = 0.0

		for j in range(spectrum.size()):
			if spectrum[j] > max_amplitude:
				max_amplitude = spectrum[j]
				max_frequency = j * sample_rate / window_size  # The frequency in hz

		# Adds the pitch for this window to the list of pitches
		pitch_values.append(max_frequency)

#Maxima: The greatest quantity or degree reached or recorded; the upper limit of variation. 
#also maxima: The time or period during which the highest point or degree is attained - google probably

# Find important notes - duh
func find_important_notes() -> Array:
	important_notes = []

	# Go through teh list of pitches that was made earlier and find local maxima
	for i in range(1, pitch_values.size() - 1):
		var prev_pitch = pitch_values[i - 1]
		var curr_pitch = pitch_values[i]
		var next_pitch = pitch_values[i + 1]

		# Check if current pitch is a local maximum (increases before, decreases after)
		if curr_pitch > prev_pitch and curr_pitch > next_pitch:
			var time_of_note = i * window_size / sample_rate
			important_notes.append(time_of_note)

	return important_notes
