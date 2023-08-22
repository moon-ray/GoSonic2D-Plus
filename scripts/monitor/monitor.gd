extends Node2D

class_name Monitor

export(float) var bump_force = 150
export(float) var gravity = 700
export(float) var ground_distance = 16

export(bool) var shield

export(int, LAYERS_2D_PHYSICS) var ground_layer = 1

export(String, "BlueShield", "ThunderShield", "FlameShield", "BubbleShield") var shield_type

onready var tree = get_tree()
onready var world = get_world_2d()

onready var icon = $Icon
onready var explosion = $Explosion0

onready var solid_object = $SolidObject
onready var animation_tree = $Sprite/AnimationTree
onready var score_controller = $ScoreController

onready var item_audio = $Audios/ItemAudio
onready var explosion_audio = $Audios/ExplosionAudio

var velocity: Vector2

var destroyed: bool
var allow_movement: bool

func _physics_process(delta):
	if allow_movement:
		handle_movement(delta)
		handle_collision()

func handle_movement(delta: float):
	velocity.y += gravity * delta
	position += velocity * delta

func handle_collision():
	var ground_hit = GoPhysics.cast_ray(world, position, transform.y, 
		ground_distance, [solid_object], ground_layer)
	
	if ground_hit:
		allow_movement = false
		velocity = Vector2.ZERO
		position.y -= ground_hit.penetration
		position = position.round()

func destroy(player):
	if not destroyed:
		explosion.play()
		if player.shields.current_shield == player.shields.shields.BubbleShield:
			var bShield = player.shields.get_node("BubbleShield")
			if bShield.descending == true:
				bShield.descending = false
				bShield.set_attacking(false)
				bShield.special_audio.play()
				bShield.animation_player.play("bounce")
		icon.set_movement(true)
		explosion_audio.play()
		solid_object.set_enabled(false)
		animation_tree.set("parameters/state/current", 1)
		handle_item(player)

func handle_item(player):
	yield(tree.create_timer(0.5), "timeout")
	item_audio.play()
	if shield:
		score_controller.add_score(player)
	else:
		score_controller.add_score()

func bump_up():
	allow_movement = true
	z_index = 0
	velocity.y = -bump_force

func _on_SolidObject_player_ceiling_collision(player: Player):
	if player.velocity.y <= 0:
		bump_up()

func _on_SolidObject_player_ground_collision(player: Player):
	if player.is_rolling and player.velocity.y > 0:
		player.velocity.y = -player.velocity.y
		destroy(player)

func _on_SolidObject_player_left_wall_collision(player: Player):
	if player.is_grounded() and player.is_rolling:
		destroy(player)

func _on_SolidObject_player_right_wall_collision(player: Player):
	if player.is_grounded() and player.is_rolling:
		destroy(player)
