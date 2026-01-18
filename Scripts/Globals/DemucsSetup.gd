extends Node

#Find if demucs is installed 
func find_demucs() -> String:
	var candidates = [
		"demucs",
		"/usr/bin/demucs",
		OS.get_user_data_dir() + "/demucs/venv/bin/demucs"
	]

	for c in candidates:
		var out := []
		if OS.execute(c, ["--version"], out, true) == 0:
			return c
		#If not, open the pypi page for demucs for the player to install
		else:
			OS.shell_open("https://pypi.org/project/demucs/")
	return ""


@onready var file_dialog := $FileDialog

#Have the player choose an mp3
func _on_select_song_pressed():
	file_dialog.popup_centered()

func _on_FileDialog_file_selected(path: String):
	process_song(path)

#Run demucs
func process_song(mp3_path: String):
	var thread := Thread.new()
	thread.start(_run_demucs.bind(mp3_path))


func _run_demucs(mp3_path: String):
	var output_dir = OS.get_user_data_dir() + "/separated"
	DirAccess.make_dir_recursive_absolute(output_dir)

	var args = [
		"-n", "htdemucs",
		"-o", output_dir,
		mp3_path
	]

	var output := []
	var exit_code = OS.execute("demucs", args, output, true)

	if exit_code == 0:
		call_deferred("_on_demucs_finished", mp3_path, output_dir)
	else:
		call_deferred("_on_demucs_failed", output)

#Example of what to do to load it i think
func _on_demucs_finished(mp3_path: String, base_dir: String):
	var song_name = mp3_path.get_file().get_basename()
	var stem_dir = base_dir + "/htdemucs/" + song_name + "/"

	load_stem("drums", stem_dir + "drums.wav")
	load_stem("bass", stem_dir + "bass.wav")
	load_stem("vocals", stem_dir + "vocals.wav")

func load_stem(fileName: String, path: String):
	var stream = AudioStreamWAV.load_from_file(path)
	var player = AudioStreamPlayer.new()
	player.stream = stream
	add_child(player)
