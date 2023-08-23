extends PlayerState

class_name TransformPlayerState

func exit(player: Player):
	player.skin.transitioning_pallete = false

func enter(player: Player):
	player.audios.transform_audio.play()
	player.skin.transitioning_pallete = true
	player.skin.pal_swapper.play("Transform")
	player.velocity.x = 0
	player.velocity.y = 0
	player.rotation_degrees = 0
	yield(get_tree().create_timer(0.9), "timeout")
	player.set_super_state(true)
	player.state_machine.change_state("Air")
	
func animate(player: Player, delta):
	player.skin.set_animation_speed(1)
	player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.transform)
	
func step(player: Player, delta):
	pass

