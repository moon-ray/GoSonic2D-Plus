extends Control

onready var anim = $Dpad/AnimationPlayer
var fading = false
var fading_2 = false

func _ready():
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		visible = true
	else:
		if !OS.is_debug_build():
			visible = false
func _process(delta):
	if $Buttons/B.self_modulate.a == 0:
		$Buttons/B.visible = false
	else:
		$Buttons/B.visible = true
	if get_parent().get_parent().player.can_transform and get_parent().get_parent().player.state_machine.current_state == "Air":
		if fading == false and !$Buttons/B.self_modulate.a == 1:
			fade_in_b()
	elif !$Buttons/B.self_modulate.a == 0 and !fading:
		if !get_parent().get_parent().player.state_machine.current_state == "Transform":
			fade_out_b()
	if modulate.a == 1 and !fading_2:
		if get_parent().get_parent().player.state_machine.current_state == "Victory":
			fade_in()
	
	if Input.is_action_pressed("player_right"):
		anim.play("right")
		
	elif Input.is_action_pressed("player_left"):
		anim.play("left")
		
	elif Input.is_action_pressed("player_up"):
		anim.play("up")
		
	elif Input.is_action_pressed("player_down"):
		anim.play("down")
		
	else:
		anim.play("neutral")

func fade_in_b():
	if fading == true:
		fading = false
	fading = true
	while fading:
		yield(get_tree().create_timer(0.1), "timeout")
		$Buttons/B.self_modulate.a += 0.5
		if $Buttons/B.self_modulate.a >= 1:
			$Buttons/B.self_modulate.a = 1
			fading = false
			
func fade_out_b():
	if fading == true:
		fading = false
	fading = false
	fading = true
	while fading:
		yield(get_tree().create_timer(0.1), "timeout")
		$Buttons/B.self_modulate.a -= 0.5
		if $Buttons/B.self_modulate.a <= 0:
			$Buttons/B.self_modulate.a = 0
			fading = false

func fade_in():
	if fading_2 == true:
		fading_2 = false
	fading_2 = false
	fading_2 = true
	while fading_2:
		yield(get_tree().create_timer(0.1), "timeout")
		modulate.a -= 0.5
		if modulate.a <= 0:
			modulate.a = 0
			fading_2 = false
			
func fade_out():
	if fading_2 == true:
		fading_2 = false
	fading_2 = false
	fading_2 = true
	while fading_2:
		yield(get_tree().create_timer(0.1), "timeout")
		modulate.a += 0.5
		if modulate.a >= 1:
			modulate.a = 1
			fading_2 = false
