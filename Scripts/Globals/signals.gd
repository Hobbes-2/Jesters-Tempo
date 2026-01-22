extends Node2D

signal IncrementScore(incr: int)

signal IncrementCombo()
signal ResetCombo()

signal CreateFallingKey(button_name: String)
signal KeyListenerPress(button_name: String, array_num: int)




var audio_stream : AudioStreamMP3
var sample_rate : int
var samples : PackedByteArray
var window_size : int = 1024  # Size of the window for FFT
var pitch_values : Array = []
var important_notes : Array = []

func _ready():
	# Load the MP3 and get its sample data
	audio_stream = load("res://your_audio_file.mp3") as AudioStreamMP3
	sample_rate = audio_stream.get_sample_rate()
	samples = audio_stream.get_data()

	# pre-analysis of the pitch
	track_pitch()

	# find important notes from pitch
	important_notes = find_important_notes()

	print("Important note at:", important_notes)

# Track pitch over time
func track_pitch():
	# Checks the data in sizes of windwo size - maybe i gotta set this to bpm related smthin?
	for i in range(0, samples.size() - window_size, window_size):
		var window = samples.slice(i, i + window_size)

		# fourier it :hehe: to get the frequency spectrum
		var fft # <- this should be the audio byte data but im tired and dont know how to get or store it
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
	var important_notes = []

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
