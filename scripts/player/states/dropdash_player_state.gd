extends PlayerState

class_name DropDashPlayerState

var dropdash_dust = preload("res://objects/particles/DropDashDust.tscn")

func enter(host: Player):
	pass
func step(host, delta):
	var drpspd = host.drpspd
	var drpmax = host.drpmax
	var drpspdsup = host.drpspdsup
	var drpmaxsup = host.drpmaxsup
	
	# This if statement is to check if the player is facing backwards.
	# (If you are facing right but you are moving left)
	
	if (host.velocity.x < 0 and direction(host) == 1) or (host.velocity.x > 0 and direction(host) == -1):
		if host.ground_angle == 0: # If player is flat on the ground
			host.velocity.x = drpspd * direction(host)
		else:
			host.velocity.x = ((host.velocity.x/2)+(drpspd*direction(host)))
	else:
		host.velocity.x = ((host.velocity.x/4)+(drpspd*direction(host)))
	host.audios.spindashrelease.play()
	host.delay_cam = true
	var dust = dropdash_dust.instance()
	dust.global_position = host.skin.get_node("DropDustSpawn").global_position
	if direction(host) == -1:
		dust.offset.x = -17
	dust.scale.x = direction(host)
	host.get_parent().add_child(dust)
	host.state_machine.change_state("Rolling")

func exit(player: Player):
	player.audios.dropdash.stop()

func direction(player):
	if player.skin.flip_h == true:
		return -1
	else:
		return 1

# This script was based on the SOnic Retro Physics Guide.
# Check it out here:
# https://info.sonicretro.org/SPG:Special_Abilities#Drop_Dash_.28Mania.29
