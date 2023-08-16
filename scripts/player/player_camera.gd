extends Camera2D

class_name PlayerCamera

export(float) var high_velocity_speed = 960
export(float) var low_velocity_speed = 360
export(float) var high_velocity_xsp = 480
export(float) var right_margin = 0
export(float) var left_margin = -16
export(float) var top_margin = -32
export(float) var bottom_margin = 32

var player: Player

var delay_timer: float = 0
var is_delaying: bool = false
var delay_duration: float = 0.2
var original_target_position: Vector2



func _ready():
	initialize_camera()

func _physics_process(delta):	
	if delay_timer > 0:
		delay_timer -= delta
		if delay_timer <= 0:
			original_target_position = Vector2.ZERO
	else:
		handle_horizontal_borders(delta)
		handle_vertical_borders(delta)
		
	if player.delay_cam == true:
		player.delay_cam = false
		start_camera_delay()

func initialize_camera():
	current = true

func set_player(desired_player: Player):
	player = desired_player
	position = player.global_position

func set_limits(left: int, right: int, top: int, bottom: int):
	limit_left = left
	limit_right = right
	limit_top = top
	limit_bottom = bottom

func handle_horizontal_borders(delta: float):
	var target = player.get_position().x
	
	if target > position.x + right_margin:
		var offset = target - position.x - right_margin
		position.x += min(offset, high_velocity_speed * delta)
	
	if target < position.x + left_margin:
		var offset = target - position.x - left_margin
		position.x += max(offset, -high_velocity_speed * delta)

func handle_vertical_borders(delta: float):
	var target = player.get_position().y
	
	if player.is_grounded():
		var offset = target - position.y
		var is_at_high_velocity = player.velocity.x <= high_velocity_xsp
		var speed = low_velocity_speed if is_at_high_velocity else high_velocity_speed
		position.y += clamp(offset, -speed * delta, speed * delta)
	else:
		if target < position.y + top_margin :
			var offset = target - position.y - top_margin
			position.y += max(offset, -high_velocity_speed * delta)
		
		if target > position.y + bottom_margin:
			var offset = target - position.y - bottom_margin
			position.y += min(offset, high_velocity_speed * delta)
			
func start_camera_delay():
    delay_timer = delay_duration
    original_target_position = player.get_position()
	

#func _draw():
#	var right = Vector2.RIGHT * right_margin
#	var left = Vector2.RIGHT * left_margin
#	var top_left = Vector2.UP * -top_margin + left
#	var top_right = Vector2.UP * -top_margin + right
#	var bottom_left = Vector2.DOWN * bottom_margin + left
#	var bottom_right = Vector2.DOWN * bottom_margin + right
#	draw_line(top_left, bottom_left, Color.white)
#	draw_line(top_right, bottom_right, Color.white)
#	draw_line(top_left, top_right, Color.white)
#	draw_line(bottom_left, bottom_right, Color.white)
#	draw_line(right, left, Color.green)
