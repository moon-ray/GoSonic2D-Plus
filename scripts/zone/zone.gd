extends Node2D

class_name Zone

export(PackedScene) var player_resource
export(PackedScene) var camera_resource
export(PackedScene) var death_handler_resource
export(PackedScene) var fade_manager_resource
export(AudioStream) var zone_music

export(float) var limit_left = 0
export(float) var limit_right = 10000
export(float) var limit_top = 0
export(float) var limit_bottom = 10000

onready var start_point = $StartPoint

var player: Player
var camera: PlayerCamera
var death_handler: DeathChecker
var fade_manager: FadeManager

onready var hud = $CanvasLayer/HUD

func _ready():
	initialize_fade_manager()
	initialize_player()
	initialize_camera()
	initialize_death_handler()
	_zone_music()
	fade_manager.fade_out()

func initialize_player():
	player = player_resource.instance()
	player.position = start_point.position
	player.lock_to_limits(limit_left, limit_right)
	add_child(player)

func initialize_death_handler():
	death_handler = death_handler_resource.instance()
	add_child(death_handler)

func initialize_fade_manager():
	fade_manager = fade_manager_resource.instance()
	add_child(fade_manager)

func initialize_camera():
	camera = camera_resource.instance()
	camera.set_player(player)
	camera.set_limits(limit_left, limit_right, limit_top, limit_bottom)
	add_child(camera)

func _zone_music():
	MusicManager.play_music(zone_music)
