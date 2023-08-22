extends Sprite

class_name PlayerSkin

onready var animation_tree = $AnimationTree

onready var player = get_parent()

const ANIMATION_STATES = {
	"idle": 0,
	"walking": 1,
	"running": 2,
	"peel_out": 3,
	"rolling": 4,
	"skidding": 5,
	"corkscrew": 6,
	"crouch": 7,
	"spindash": 8,
	"lookup": 9,
	"dropdash": 10,
	"balance": 11,
	"panic_balance": 12,
	"idle_wait": 13,
	"pushing": 14,
	"dead": 15,
	"hurt": 16,
}

var off_screen = false

var current_state : int

var idle_timer = false

func _process(delta):
	# print($idle_timer.time_left)
	$SpinDashDust.flip_h = flip_h
	if $SpinDashDust.flip_h == true:
		$SpinDashDust.offset.x = 32
	else:
		$SpinDashDust.offset.x = 0
		
	if current_state == 0:
		if not idle_timer:
			$idle_timer.start()
			idle_timer = true
	else:
		idle_timer = false
		$idle_timer.stop()
		animation_tree.set("parameters/idle-shot/active", false)


func handle_flip(direction: float) -> void:
	if !player.is_looking_down:
		if !player.is_looking_up:
			if direction != 0:
				flip_h = direction < 0
				$SpinDashDust.flip_h = direction < 0
				if $SpinDashDust.flip_h == true:
					$SpinDashDust.offset.x = 32
				else:
					$SpinDashDust.offset.x = 0
	if !player.is_looking_up:
		if !player.is_looking_down:
			if direction != 0:
				flip_h = direction < 0
func set_animation_state(state: int) -> void:
	if state != current_state:
		current_state = state
		animation_tree.set("parameters/state/current", current_state)

func set_running_animation_state(speed: float) -> void:
	var state = ANIMATION_STATES.walking
	
	if speed > 355 and speed <= 595:
		state = ANIMATION_STATES.running
	elif speed > 595:
		state = ANIMATION_STATES.peel_out
	
	set_animation_state(state)

func set_animation_speed(value: float) -> void:
	animation_tree.set("parameters/speed/scale", value)

func set_regular_animation_speed(value: float) -> void:
	var speed = max(8.0 / 60.0 + value / 120.0, 1.0)
	set_animation_speed(speed)

func set_rolling_animation_speed(value: float) -> void:
	var speed = max(4 / 60.0 + value / 120.0, 1.0)
	set_animation_speed(speed)


func _on_idle_timer_timeout():
	animation_tree.set("parameters/idle-shot/active", true)


func _on_exit_screen():
	if player.state_machine.current_state == "Dead":
		off_screen = true
		visible = false
