extends Node2D

class_name FadeManager

onready var animation = $AnimationPlayer

func fade_in():
	if !animation.current_animation == "fade_in":
		animation.play("fade_in")
	
func fade_out():
	if !animation.current_animation == "fade_out":
		animation.play("fade_out")
