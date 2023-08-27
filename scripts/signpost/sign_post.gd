extends Node2D

class_name Signpost

var player : Player
var camera : PlayerCamera
onready var zone = get_parent()

var routined = false

var displayed = false

func _physics_process(delta):
	player = zone.player
	camera = zone.camera
	if player != null:
		if player.global_position.x >= global_position.x and !displayed and !routined:
			spin()
			player.spun_sign_post = true
			routined = true
			player.skin.off_screen = true
			player.set_super_state(false)
			ScoreManager.stop_time_goal()
			camera.limit_left = camera.limit_right
			player.lock_to_limits(camera.limit_right - 426, camera.limit_right)
			yield(get_tree().create_timer(2), "timeout")
			display_plate(player.player_id)
			MusicManager.fade_out(3)
			player.victory_anim()
			yield(get_tree().create_timer(0.6), "timeout")
			ScoreTally.enter(player.player_id, zone.act_number)
			while MusicManager.fading:
				yield(get_tree().create_timer(0.1), "timeout")
			MusicManager.reset_volume()
			MusicManager.play_music(zone.victory_music)
			while MusicManager.is_playing():
				yield(get_tree().create_timer(0.1), "timeout")
			ScoreTally.tally_total()
			while ScoreTally.is_tallying():
				yield(get_tree().create_timer(0.1), "timeout")
			yield(get_tree().create_timer(2), "timeout")
			ScoreTally.exit()
			yield(get_tree().create_timer(1.0), "timeout")
			if player.state_machine.current_state == "Dead":
				return
			FadeManager.fade_in()
			yield(get_tree().create_timer(2), "timeout")
			go_data.save_file()
			global_load.load_scene(get_tree().root.get_node("Zone"),get_parent().next_scene)
			
			

func spin():
	if !$AnimationPlayer.current_animation == "spin":
		$AnimationPlayer.play("spin")
		$Spin.play()

func display_plate(character):
	$AnimationPlayer.play(character)
	displayed = true
	
