extends PlayerState

class_name RollingPlayerState

func enter(player: Player):
	if !player.state_machine.last_state == "SpinDash":
		if !player.state_machine.last_state == "DropDash":
			player.audios.spin_audio.play()
	elif !player.state_machine.last_state == "DropDash":
		if !player.state_machine.last_state == "SpinDash":
			player.audios.spin_audio.play()
	player.is_rolling = true
	player.set_bounds(1)

func step(player: Player, delta: float):
	player.handle_fall()
	player.handle_gravity(delta)
	player.handle_jump()
	player.handle_slope(delta)
	player.handle_deceleration(delta)
	player.handle_friction(delta)
	
	if player.is_grounded():
		if abs(player.velocity.x) < player.current_stats.unroll_speed:
			player.is_rolling = false
			player.state_machine.change_state("Regular")
	else:
		player.state_machine.change_state("Air")

func animate(player: Player, _delta: float):
	player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.rolling)
	player.skin.set_rolling_animation_speed(abs(player.velocity.x))
