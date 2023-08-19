extends Shield

class_name ThunderShield

export(float) var vertical_force = -330

onready var sprite = $Sprite
onready var animation_player = $Sprite/AnimationPlayer
onready var collision = $Magnetize/CollisionShape2D

onready var player = get_parent().get_parent()

var particle = preload("res://objects/particles/electric_sparkles.tscn")

func _ready():
	sprite.visible = false
	collision.set_deferred("disabled", true)

func on_activate():
	sprite.visible = true
	animation_player.play("default")
	collision.set_deferred("disabled", false)

func on_deactivate():
	sprite.visible = false
	animation_player.stop()
	collision.set_deferred("disabled", true)

func on_action():
	shield_user.velocity.y = vertical_force
	var sparkle = particle.instance()
	sparkle.global_position = player.global_position
	player.get_parent().add_child(sparkle)
