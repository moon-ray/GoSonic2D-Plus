extends PlayerState

class_name AirPlayerState

var last_absolute_horizontal_speed: float
var can_use_shield: bool
var drop_dash : bool
var can_drop_dash : bool

onready var audio_player = get_parent().get_parent().get_node("Audios")

func enter(player: Player):
	can_use_shield = player.is_rolling
	last_absolute_horizontal_speed = abs(player.velocity.x)
	
	if player.is_rolling:
		player.set_bounds(1)

func step(player: Player, delta: float):
	player.handle_gravity(delta)
	player.handle_jump()
	player.handle_acceleration(delta)

	if player.is_grounded():
		if !drop_dash:
			if player.input_direction.y < 0:
				player.state_machine.change_state("Rolling")
			else:
				player.state_machine.change_state("Regular")
		elif drop_dash:
			can_drop_dash = false
			drop_dash = false
			player.state_machine.change_state("DropDash")
		$DropDashTimer.stop()
		
	elif Input.is_action_just_pressed("player_b") and player.can_transform:
		player.state_machine.change_state("Transform")
		
	elif (Input.is_action_just_pressed("player_a") or Input.is_action_just_pressed("player_b")) and can_use_shield:
		can_use_shield = false
		player.shields.use_current()

	if Input.is_action_just_pressed("player_a") and player.is_rolling:
		drop_dash_checks(player)
	elif Input.is_action_just_pressed("player_b") and player.is_rolling and !player.can_transform:
		drop_dash_checks(player)
		
	if Input.is_action_just_released("player_a") or Input.is_action_just_released("player_b"):
		$DropDashTimer.stop()
		can_drop_dash = true
		drop_dash = false
		
func exit(player: Player):
	$DropDashTimer.stop()
	can_drop_dash = true
	drop_dash = false

func animate(player: Player, _delta: float):
	player.skin.handle_flip(player.input_direction.x)
	if player.state_machine.last_state == "Transform":
		player.skin.set_running_animation_state(last_absolute_horizontal_speed)
	elif !drop_dash:
		if player.is_rolling:
			player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.rolling)
			player.skin.set_rolling_animation_speed(last_absolute_horizontal_speed)
		elif player.state_machine.last_state == "Regular":
			player.skin.set_running_animation_state(last_absolute_horizontal_speed)
		else:
			player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.walking)
	elif drop_dash:
		player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.dropdash)


func dropdash_timer_timeout():
	if !drop_dash:
		audio_player.dropdash.play()
		drop_dash = true
		can_drop_dash = false

func drop_dash_checks(player):
	if player.shields.current_shield == player.shields.shields.InstaShield:
		if can_drop_dash:
			$DropDashTimer.start()
	elif player.shields.current_shield == player.shields.shields.BlueShield:
		if can_drop_dash:
			$DropDashTimer.start()
	elif player.super_state:
		if can_drop_dash:
			$DropDashTimer.start()
