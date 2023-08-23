extends PlayerState

class_name RegularPlayerState

var can_turn : bool

onready var host = get_parent().get_parent()

func enter(player: Player):
	#can_turn = true
	player.set_bounds(0)

func step(player: Player, delta: float):
	player.is_looking_down = false
	player.is_looking_up = false
	player.is_pushing = false
	
	if player.__is_grounded and Input.is_action_pressed("player_down") and Input.is_action_just_pressed("player_a") and !player.is_pushing:
		player.state_machine.change_state("SpinDash")
	elif player.__is_grounded and Input.is_action_pressed("player_up") and Input.is_action_just_pressed("player_a"):
		if abs(player.velocity.x) < player.current_stats.min_speed_to_roll and !player.is_pushing:
			player.state_machine.change_state("SuperPeelOut")
	else:
		player.handle_jump()
	player.handle_fall()
	player.handle_gravity(delta)
	player.handle_slope(delta)
	player.handle_acceleration(delta)
	player.handle_friction(delta)

	if player.is_grounded():
		if player.input_direction.x > 0 and player.right_push.is_colliding():
			player.is_pushing = true
		elif player.input_direction.x < 0 and player.left_push.is_colliding():
			player.is_pushing = true
		else:
			player.is_pushing = false
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
	else:
		player.state_machine.change_state("Air")

func animate(player: Player, _delta: float):
	var leftSensorRaycast = player.ledge_left
	var rightSensorRaycast = player.ledge_right
	var middleSensorRaycast = player.ledge_mid
	var middleRightSensor = player.ledge_mid_right
	var middleLeftSensor = player.ledge_mid_left
	
	var left_sensor_collision = leftSensorRaycast.is_colliding()
	var right_sensor_collision = rightSensorRaycast.is_colliding()
	var middle_sensor_collision = middleSensorRaycast.is_colliding()
	var middleL_sensor_collision = middleLeftSensor.is_colliding()
	var middleR_sensor_collision = middleRightSensor.is_colliding()
	
	var absolute_speed = abs(player.velocity.x)
	player.skin.handle_flip(player.input_direction.x)
	player.skin.set_regular_animation_speed(absolute_speed)
	
	if absolute_speed >= 0.3:
		player.skin.set_running_animation_state(absolute_speed)
	elif player.is_pushing:
		player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.pushing)
	elif not player.is_looking_down and not player.is_looking_up:
		if left_sensor_collision == right_sensor_collision and middle_sensor_collision:
			idle()
		elif left_sensor_collision != right_sensor_collision and absolute_speed == 0 and abs(player.ground_angle) <= 3:
			if !left_sensor_collision && right_sensor_collision:
				if !middle_sensor_collision:
					balance("panic", player)
					player.skin.flip_h = true
				elif !middleL_sensor_collision:
					balance("balance", player)
					player.skin.flip_h = true
				else:
					host.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.idle)
			elif left_sensor_collision && !right_sensor_collision:
				if !middle_sensor_collision:
					balance("panic", player)
					player.skin.flip_h = false
				elif !middleR_sensor_collision:
					balance("balance", player)
					player.skin.flip_h = false
				else:
					host.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.idle)
			else:
				idle()
		else:
			idle()
	else:
		if player.is_looking_up:
			player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.lookup)
		elif player.is_looking_down:
			player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.crouch)
		else:
			idle()
func exit(player: Player):
	player.is_pushing = false
	player.is_looking_down = false
	player.is_looking_up = false

func idle():
	if !host.super_state:
		host.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.idle)
	else:
		host.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.idle_super)
func balance(type: String, player):
	if player.super_state:
		player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.balancing_super)
	else:
		if type == "panic":
			player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.panic_balance)
		else:
			player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.balance)
