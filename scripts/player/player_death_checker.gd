extends Node2D

class_name DeathChecker

onready var player = get_parent().player

export(AudioStream) var game_over

var routined = false
var can_skip = false
var can_time_skip = false

onready var zone_music = get_parent().get_node("ZoneMusic")
onready var animation_ui = get_parent().hud.get_node("AnimationPlayer")
onready var life_counter = get_parent().hud.get_node("Lifes").get_node("Counter")

func _ready():
	routined = false


func _process(delta):
	var press_a = Input.is_action_just_pressed("player_a")
	var acceptpr = Input.is_action_just_pressed("ui_accept")

	var player_state = player.state_machine.current_state
	if player_state == "Dead":
		_handle_death()

	if (press_a and can_skip) or (acceptpr and can_skip):
		MusicManager.fade_out(2)
		skip_gameover()
		can_skip = false

	if (press_a and can_time_skip) or (acceptpr and can_time_skip):
		MusicManager.fade_out(2)
		skip()
		can_time_skip = false

func _handle_death():
	if !routined:
		player.pause_mode = PAUSE_MODE_PROCESS
		get_tree().paused = true
		
		ScoreManager.lifes -= 1 # subtract lives to ensure proper calculations
		
		var current_time = round(ScoreManager.time)
		var time_limit = ScoreManager.TIME_LIMIT
		var lives = ScoreManager.lifes
		
		routined = true # just to prevent it from running over and over again
		ScoreManager.time_stoped = true
		
		while !player.skin.off_screen: # Waits until player is off screen
			yield(get_tree().create_timer(0.1), "timeout")
			
		
		yield(get_tree().create_timer(1), "timeout") # Waits 1 second for dramatic effect
		
		life_counter.set_text(str(ScoreManager.lifes)) # doing this manually because it doesnt update when paused
		
		if lives > 0 and !current_time == time_limit: # If lives > 0 and player hasnt reached time limit
			MusicManager.fade_out(2)
			skip()
		elif !lives == 0 and current_time == time_limit: # If player has lives and player has reached time limit
			can_time_skip = true
			game_over_music()
			animation_ui.play("timeover")
			yield(get_tree().create_timer(game_over.get_length()), "timeout")
			MusicManager.fade_out(2)
			skip()
		else: # If player has no lives, doesn't matter if player has reached time limit or not
			can_skip = true
			game_over_music()
			animation_ui.play("gameover")
			yield(get_tree().create_timer(game_over.get_length()), "timeout")
			MusicManager.fade_out(2)
			skip_gameover()

func skip_gameover():
	get_parent().fade_manager.fade_in()
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().paused = false
	global_load.load_scene(get_tree().root.get_node("Zone"),"res://scenes/main.tscn")
	_reset_scores()
	ScoreManager.lifes = 3
	
func skip():
	get_parent().fade_manager.fade_in()
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().paused = false
	global_load.load_scene(get_tree().root.get_node("Zone"),"res://scenes/main.tscn")
	_reset_scores()

func _reset_scores():
	ScoreManager.reset_score(true, true, true)
	ScoreManager.time_stoped = false
	#if ScoreManager.lifes == 0:
		#get_tree().quit()
func game_over_music():
	MusicManager.play_music(game_over)
