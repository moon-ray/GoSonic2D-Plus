extends Control

export(AudioStream) var music
export(Texture) var godot
export(Texture) var demo_start

var activated_godot : bool = false
var loop = true

onready var no_way = $"No Way!"

func _ready():
	go_data.load_file()
	FadeManager.fade_out()
	MusicManager.play_music(music)
	$Start.visible = true
	
func _process(delta):
	if (Input.is_action_just_pressed("player_a") or Input.is_action_just_pressed("ui_accept")) and !activated_godot:
		$Start/AnimationPlayer.play("blink")
		$sound.play()
		change_no_way_texture(demo_start)
		yield(get_tree().create_timer(2), "timeout")
		FadeManager.fade_in()
		MusicManager.fade_out(2)
		yield(get_tree().create_timer(2), "timeout")
		global_load.load_scene(self,"res://scenes/main.tscn")
		ScoreManager.reset_score(false, true, true)
		ScoreManager.time_stopped_goal = false
		
func change_no_way_texture(texture):
	activated_godot = true
	for child in $"No Way!".get_children():
		child.texture = texture
func hide_no_way():
	activated_godot = true
	$sound.play()
	for child in $"No Way!".get_children():
		if !child.name == "DemoStart":
			child.visible = false
