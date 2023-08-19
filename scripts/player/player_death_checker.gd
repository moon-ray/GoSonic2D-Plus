extends Node2D

class_name DeathChecker

func _process(delta):
	if get_parent().player.state_machine.current_state == "Dead":
		yield(get_tree().create_timer(2.0), "timeout")
		ScoreManager.reset_score(true, true, true)
		ScoreManager.lifes -= 1
		get_tree().paused = false
		
		if ScoreManager.lifes == 0:
			get_tree().quit()
		get_tree().change_scene("res://scenes/main.tscn")

func _on_restart_time_timeout():
	get_tree().change_scene("res://scenes/main.tscn")
	get_tree().paused = false
