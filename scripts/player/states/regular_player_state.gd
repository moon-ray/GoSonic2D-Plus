extends PlayerState

class_name RegularPlayerState

var can_turn : bool

func enter(player: Player):
	#can_turn = true
	player.set_bounds(0)

func step(player: Player, delta: float):
	print("UP %s" % player.is_looking_up)
	print("DOWN %s" % player.is_looking_down)
	
	player.is_looking_down = false
	player.is_looking_up = false
	
	if player.__is_grounded and Input.is_action_pressed("player_down") and Input.is_action_just_pressed("player_a"):
		player.state_machine.change_state("SpinDash")
	elif player.__is_grounded and Input.is_action_pressed("player_up") and Input.is_action_just_pressed("player_a"):
		if abs(player.velocity.x) < player.current_stats.min_speed_to_roll:
			player.state_machine.change_state("SuperPeelOut")
	else:
		player.handle_jump()
	player.handle_fall()
	player.handle_gravity(delta)
	player.handle_slope(delta)
	player.handle_acceleration(delta)
	player.handle_friction(delta)

	if player.is_grounded():
		if player.input_dot_velocity < 0 and abs(player.velocity.x) >= player.current_stats.min_speed_to_brake:
			player.state_machine.change_state("Braking")
		if player.input_direction.y < 0 and abs(player.velocity.x) > player.current_stats.min_speed_to_roll:
			player.state_machine.change_state("Rolling")
		elif player.input_direction.y < 0 and abs(player.velocity.x) < player.current_stats.min_speed_to_roll:
			player.velocity.x = 0
			player.is_looking_down = true
		elif player.input_direction.y > 0 and abs(player.velocity.x) < player.current_stats.min_speed_to_roll:
			player.velocity.x = 0
			player.is_looking_up = true
		if player.is_looking_down == true:
			can_turn = false
		if player.is_looking_up == true:
			can_turn = false

		if player.is_looking_down == false:
			can_turn = true
		if player.is_looking_up == false:
			can_turn = true

	else:
		player.state_machine.change_state("Air")
	



func animate(player: Player, _delta: float):
	var absolute_speed = abs(player.velocity.x)
	if can_turn == true:
		player.skin.handle_flip(player.input_direction.x)
	player.skin.set_regular_animation_speed(absolute_speed)
	
	if absolute_speed >= 0.3:
		player.skin.set_running_animation_state(absolute_speed)
	elif not player.is_looking_down and not player.is_looking_up:
		player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.idle)
	else:
		if player.is_looking_up:
			player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.lookup)
		if player.is_looking_down:
			player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.crouch)
