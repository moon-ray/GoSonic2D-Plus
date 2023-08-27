extends KinematicBody2D

class_name Ring

var is_ring = false

onready var sprite = $Sprite
onready var collider = $Area2D/CollisionShape2D
onready var score_controller = $ScoreController
onready var ring_sparkle = $RingSparkle
onready var ring_audio = $RingAudio

var magnetised = false
export var gravitised = false

const turn_speed = 0.5
const follow_speed = 0.3

var velocity = Vector2(0,0)
var gravity = 16

var y_speed : float
var x_speed : float

var position_tracker : Position2D

var ring_acceleration = [turn_speed, follow_speed]

var _player : Player
var bounce_damp = 100
var bounce = 500

var ring_drop = globalvars.ring_drop

func collect(player):
	gravitised = false
	magnetised = false
	player.audios.ring_audio.play()
	ring_sparkle.play()
	sprite.visible = false
	score_controller.add_score()
	collider.set_deferred("disabled", true)
	
func _ready():
	if gravitised:
		$despawn.start()

func _on_Area2D_area_entered(area):
	var player = area.get_parent()
	
	if player is Player:
		if player.can_collect_rings == true:
			collect(player)

	if player.name == "ThunderShield":
		_player = player.player
		magnetised = true
		
func _physics_process(delta):
	if magnetised:
		
		var sx = sign(_player.position.x - position.x)
		var sy = sign(_player.position.y - position.y)
		
		var tx = int((sign(x_speed) == sx))
		var ty = int((sign(y_speed) == sy))
		
		x_speed += (ring_acceleration[tx] * sx)
		y_speed += (ring_acceleration[ty] * sy)
		
		position.x += x_speed;
		position.y += y_speed;
	if gravitised:
		velocity.y += gravity
		if is_on_floor():
			if ring_drop:
				if should_bounce():
					_bounce()
				else:
					$Collision.set_deferred("disabled", true)
			else:
				_bounce()

		
		velocity = move_and_slide(velocity,Vector2.UP)


func _on_despawn():
	$despawn.stop()
	if !$fade.current_animation == "fade":
		$fade.play("fade")
	collider.set_deferred("disabled", true)


func _on_screen_exited():
	hide()
	

func _on_screen_entered():
	show()

func should_bounce():
	var random_generator = RandomNumberGenerator.new()
	random_generator.randomize()
	
	var random_number = random_generator.randf_range(0.0, 1.0)
	return random_number <= 0.9

func _on_fade_animation_finished(_anim_name):
	if collider.disabled == true:
		queue_free()

func _bounce():
	velocity.y -= bounce
	bounce -= bounce_damp
	if bounce < 0:
		bounce = 0

