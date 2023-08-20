extends Node2D

class_name DeathChecker

onready var player = get_parent().player

export(AudioStream) var game_over

var routined = false
var can_skip = false
var can_time_skip = false

func _ready():
	routined = false


func _process(delta):
	var press_a = Input.is_action_just_pressed("player_a")
	var acceptpr = Input.is_action_just_pressed("ui_accept")

	var player_state = player.state_machine.current_state
	if player_state == "Dead":
		_handle_death()

	if press_a and can_skip == true or acceptpr and can_skip == true:
		skip_gameover()
		can_skip = false

	if press_a and can_time_skip == true or acceptpr and can_time_skip == true:
		skip()
		can_time_skip = false

func _handle_death():
	if !routined:
		routined = true
		print("start of routine")
		ScoreManager.time_stoped = true
		yield(get_tree().create_timer(2.0), "timeout")
		ScoreManager.lifes -= 1
		get_parent().hud.get_node("Lifes").get_node("Counter").set_text(str(ScoreManager.lifes))
		if ScoreManager.lifes > 0 and !round(ScoreManager.time) == ScoreManager.TIME_LIMIT:
			print("lifes > 0")
			skip()
		elif !ScoreManager.lifes == 0 and round(ScoreManager.time) == ScoreManager.TIME_LIMIT:
			print("elif statement")
			can_time_skip = true
			get_parent().get_node("ZoneMusic").stop()
			get_parent().get_node("ZoneMusic").stream = game_over
			get_parent().get_node("ZoneMusic").play()
			get_parent().hud.get_node("AnimationPlayer").play("timeover")
			yield(get_tree().create_timer(12.0), "timeout")
			skip()
		else:
			can_skip = true
			print("else statement")
			get_parent().get_node("ZoneMusic").stop()
			get_parent().get_node("ZoneMusic").stream = game_over
			get_parent().get_node("ZoneMusic").play()
			get_parent().hud.get_node("AnimationPlayer").play("gameover")
			yield(get_tree().create_timer(12.0), "timeout")
			skip_gameover()

func skip_gameover():
	get_parent().fade_manager.fade_in()
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().paused = false
	get_tree().change_scene("res://scenes/main.tscn")
	_reset_scores()
	ScoreManager.lifes = 3
	
func skip():
	get_parent().fade_manager.fade_in()
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().paused = false
	get_tree().change_scene("res://scenes/main.tscn")
	_reset_scores()

func _reset_scores():
	ScoreManager.reset_score(true, true, true)
	ScoreManager.time_stoped = false
	#if ScoreManager.lifes == 0:
		#get_tree().quit()
