extends Node

class_name ShieldController

onready var shield_type = get_parent().shield_type

onready var score_manager = get_node("/root/ScoreManager") as ScoreManager

func add_score(player):
	var shields = player.shields.shields
	if shield_type == "BlueShield":
		player.shields.change(shields.BlueShield)
	elif shield_type == "ThunderShield":
		player.shields.change(shields.ThunderShield)
	elif shield_type == "FlameShield":
		player.shields.change(shields.FlameShield)
	elif shield_type == "BubbleShield":
		player.shields.change(shields.BubbleShield)
