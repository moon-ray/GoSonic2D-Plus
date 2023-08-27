extends Node2D

onready var animation = $AnimationPlayer

func fade_in():
	if !animation.current_animation == "fade_in":
		animation.play("fade_in")
	
func fade_out():
	if !animation.current_animation == "fade_out":
		animation.play("fade_out")
func reset():
	if !animation.current_animation == "reset":
		animation.play("reset")
func prefadeout():
	animation.play("prefadeout")
