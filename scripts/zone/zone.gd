extends Node2D

class_name Zone

export(String) var zone_name
export(int) var act_number
export(String) var next_scene

export(String) var zone_path
export(PackedScene) var player_resource
export(PackedScene) var camera_resource
export(PackedScene) var death_handler_resource
export(PackedScene) var fade_manager_resource
export(AudioStream) var zone_music
export(AudioStream) var victory_music
export(PackedScene) var zone_hud

export(bool) var snowboard_level

export(float) var limit_left = 0
export(float) var limit_right = 10000
export(float) var limit_top = 0
export(float) var limit_bottom = 10000

onready var start_point = $StartPoint

var player: Player
var camera: PlayerCamera
var death_handler: DeathChecker
var global_zone_hud: CanvasLayer

var gameover : Control
var hud : Control

func _ready():
	ScoreManager.reset_score(false, true, false)
	ScoreManager.time_stopped_goal = false
	FadeManager.prefadeout()
	initialize_player()
	if snowboard_level:
		player.change_state("Snowboarding")
	initialize_camera()
	initialize_hud()
	initialize_death_handler()
	_zone_music()
	FadeManager.fade_out()
	yield(get_tree().create_timer(0.2), "timeout")
	global_zone_hud.get_node("ColorRect").visible = false
	

func initialize_player():
	player = player_resource.instance()
	player.position = start_point.position
	player.lock_to_limits(limit_left, limit_right)
	add_child(player)

func initialize_death_handler():
	death_handler = death_handler_resource.instance()
	death_handler.zone_to_reload = zone_path
	add_child(death_handler)

func initialize_camera():
	camera = camera_resource.instance()
	camera.set_player(player)
	camera.set_limits(limit_left, limit_right, limit_top, limit_bottom)
	add_child(camera)
	
func initialize_hud():
	global_zone_hud = zone_hud.instance()
	add_child(global_zone_hud)
	hud = global_zone_hud.get_node("HUD")
	gameover = global_zone_hud.get_node("GameOver")

func _zone_music():
	MusicManager.play_music(zone_music)
