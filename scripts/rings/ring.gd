extends Node2D

onready var sprite = $Sprite
onready var collider = $Area2D/CollisionShape2D
onready var score_controller = $ScoreController
onready var ring_sparkle = $RingSparkle
onready var ring_audio = $RingAudio

var magnetised = false

const turn_speed = 0.0125/3
const follow_speed = 0.003125/3

var y_speed : float
var x_speed : float

var ring_acceleration = [turn_speed, follow_speed]

var _player : Player

func collect():
	magnetised = false
	ring_audio.play()
	ring_sparkle.play()
	sprite.visible = false
	score_controller.add_score()
	collider.set_deferred("disabled", true)
	

func _on_Area2D_area_entered(area):
	var player = area.get_parent()
	
	if player is Player:
		collect()
		      #thundershield#shields#sonic
	if player.name == "ThunderShield":
		_player = player.player
		magnetised = true

func _process(delta):
	if magnetised:
		
		var sx = sign(_player.position.x - position.x)
		var sy = sign(_player.position.y - position.y)
		
		var tx = int((sign(x_speed) == sx))
		var ty = int((sign(y_speed) == sy))
		
		x_speed += (ring_acceleration[tx] * sx)
		y_speed += (ring_acceleration[ty] * sy)
		
		position.x += x_speed;
		position.y += y_speed;
