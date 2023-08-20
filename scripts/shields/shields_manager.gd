extends Node2D

class_name ShieldsManager

onready var shields = {
	"None": $None,
	"InstaShield": $InstaShield,
	"BlueShield": $BlueShield,
	"ThunderShield": $ThunderShield,
	"FlameShield": $FlameShield
}

onready var shield_user = get_parent()
onready var default_shield = shields.InstaShield

var current_shield: Shield

#func _process(delta):
	#if Input.is_action_just_pressed("player_debug"):
		#change(shields.InstaShield)

func _ready():
	change(default_shield)

func change(to: Shield):
	if current_shield:
		current_shield.deactivate()
	
	current_shield = to
	current_shield.activate(shield_user)

func change_to_default():
	change(default_shield)

func use_current():
	if current_shield:
		current_shield.action()
