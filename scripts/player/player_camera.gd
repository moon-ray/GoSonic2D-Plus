extends Camera2D

class_name PlayerCamera

export(float) var high_velocity_speed = 960.00
export(float) var low_velocity_speed = 360.00
export(float) var high_velocity_xsp = 480.00
export(float) var right_margin = 0.00
export(float) var left_margin = -16.00
export(float) var top_margin = -32.00
export(float) var bottom_margin = 32.00

var player: Player

var delay_timer: float = 0
var is_delaying: bool = false
var delay_duration: float = 0.26666666666
var original_target_position: Vector2
var scrolled_up = false
var scrolled_down = false

var stop_scroll = ""

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
		
	if player.is_looking_up:
		if stop_scroll == "back":
			yield(get_tree().create_timer(2), "timeout")
		if player.is_looking_up:
			if !stop_scroll == "up":
				scroll("up")
	elif player.is_looking_down:
		if stop_scroll == "back":
			yield(get_tree().create_timer(2), "timeout")
		if player.is_looking_down: # may look dumb, but its to check if player is still looking down.
			if !stop_scroll == "down":
				scroll("down")
		
	else:
		if !stop_scroll == "back":
			scroll("back")
func initialize_camera():
	current = true

func scroll(direction: String):
	stop_scroll = direction

	# Determine the target offset based on the direction
	var target_offset = Vector2()
	if direction == "up":
		target_offset.y = -104
		scrolled_up = true
		scrolled_down = false
	elif direction == "down":
		target_offset.y = 88
		scrolled_up = false
		scrolled_down = true

	# Scroll towards the target offset
	while offset.y != target_offset.y:
		var step = 2 * sign(target_offset.y - offset.y)
		offset.y += step
		yield(get_tree().create_timer(0.01), "timeout")

	# Check if scrolling needs to be stopped
		if stop_scroll != direction:
			break

	# Reset scrolled flags
	scrolled_up = false
	scrolled_down = false
	
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

func _on_area_entered(area):
	if area.get_parent() is Player:
		if !player.state_machine.current_state == "Dead":
			player.state_machine.change_state("Dead")
