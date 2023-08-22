extends Shield

onready var sprite = $Sprite
onready var animation_player = $Sprite/AnimationPlayer

var down_force = 8*60
var bounce_force = 7.5*60
var descending = false

export(NodePath) var action_audio_special
onready var special_audio = get_node(action_audio_special)

func _ready():
	visible = false

func on_activate():
	visible = true
	set_attacking(false)
	shield_user.connect("ground_enter", self, "on_user_ground_enter")
	animation_player.play("default")

func on_deactivate():
	descending = false
	visible = false
	animation_player.stop()

func _process(delta):
	if get_parent().current_shield == get_parent().shields.BubbleShield:
		if Input.is_action_just_pressed("player_a") and !shield_user.__is_grounded and shield_user.is_rolling:
			shield_user.velocity.x = 0
			shield_user.velocity.y = down_force
			descending = true
			set_attacking(true)
		
func set_attacking(value: bool):
	if value:
		animation_player.play("attack")
	else:
		animation_player.play("default")

func on_user_ground_enter():
	if get_parent().current_shield == get_parent().shields.BubbleShield:
		if descending == true:
			animation_player.play("bounce")
			special_audio.play()
			shield_user.state_machine.change_state("Air")
			shield_user.is_rolling = true
			if !shield_user.ground_angle == 0:
				shield_user.velocity.y -= bounce_force
			else:
				shield_user.velocity.y -= bounce_force
			descending = false
		else:
			shield_user.is_rolling = false


func _on_animation_finished(anim_name):
	if anim_name == "bounce":
		set_attacking(false)
