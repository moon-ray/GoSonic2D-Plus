extends PlayerState

class_name DeadPlayerState


func enter(host: Player):
	host.ground_angle = 0
	host.shields.visible = false
	host.audios.hurt.play()
	host.is_jumping = false
	host.is_rolling = false
	host.velocity.x = 0
	host.velocity.y = 0
	host.velocity.y -= 500
	var collision = host.get_node("Collider").get_node("Collision")
	collision.set_deferred("disabled", true)
	host.colliding = false
	host.rotation_degrees = 0
	host.skin.rotation_degrees = 0
	#print(str(host.get_children()))

func step(host, delta):
	host.velocity.y += host.current_stats.gravity * delta
	host.velocity.x = 0

func animate(player: Player, _delta: float):
	player.skin.set_animation_state(PlayerSkin.ANIMATION_STATES.dead)
	get_tree().paused = true
