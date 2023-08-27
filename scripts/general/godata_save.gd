extends Node

var save_directory = "user://godata.bin"

func save_file():
	var f = File.new()
	var err = f.open_encrypted_with_pass(save_directory, File.WRITE, "11242010")
	var data = {
		"score" : ScoreManager.score,
		"lifes" : ScoreManager.lifes,
		"lifes_added_score" : ScoreManager.lifes_added_score,
		"lifes_added" : ScoreManager.lifes_added
	}
	
	if err == OK:
		f.store_var(data)
		f.close()

func load_file():
	var f = File.new()
	if f.file_exists(save_directory):
		var err = f.open_encrypted_with_pass(save_directory, File.READ, "11242010")
		if err == OK:
			var player_data = f.get_var()
			ScoreManager.score = player_data.score
			ScoreManager.lifes = player_data.lifes
			ScoreManager.lifes_added_score = player_data.lifes_added_score
			ScoreManager.lifes_added = player_data.lifes_added
			
			f.close()
