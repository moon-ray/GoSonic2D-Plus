extends PlayerState

class_name DeadPlayerState


func enter(host: Player):
	host.shields.visible = false
	host.audios.hurt.play()
	host.is_jumping = false
	host.is_rolling = false
	host.velocity.x = 0
	host.velocity.y = 0
	host.velocity.y -= 500
	host.colliding = false

func step(host, delta):
	host.velocity.y += host.current_stats.gravity * delta
	host.velocity.x = 0

func animate(player: Player, _delta: float):
	player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.dead)
