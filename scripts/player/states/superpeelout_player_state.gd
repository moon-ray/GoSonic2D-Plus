extends PlayerState

class_name SuperPeeloutPlayerState

export(float) var DASH_SPEED = 720
export(float) var CHARGE_TIME = 1

var charge_timer : float
var animation_speed : float

var scaletemp = 1

func enter(host: Player):
	charge_timer = CHARGE_TIME
	animation_speed = 1.0
	host.audios.peeloutcharge.play()

func step(host: Player, delta):
	charge_timer -= delta
	animation_speed += (720.0 / pow(CHARGE_TIME, 2.0)) * delta
	animation_speed = min(animation_speed, 720.0)
	
	if Input.is_action_just_released("player_up"):
		host.state_machine.change_state("Regular")

func exit(host: Player):
	if charge_timer <= 0:
		if host.skin.flip_h == true:
			scaletemp = -1
		else:
			scaletemp = 1
		host.velocity.x = DASH_SPEED * scaletemp
		host.delay_cam = true
		host.audios.peeloutrelease.play()
	else:
		host.audios.peeloutcharge.stop()
		pass

func animate(host: Player, animator):
	var anim_speed = max(-(8.0 / 60.0 - (animation_speed / 120.0)), 1.0)
	host.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.walking)

	if animation_speed >= 360:
		host.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.running)
		
	if animation_speed >= 720:
		host.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.peel_out)
		
	host.skin.set_animation_speed(anim_speed)
	
