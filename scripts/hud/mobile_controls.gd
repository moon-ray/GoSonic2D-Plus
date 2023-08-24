extends Control

onready var anim = $Dpad/AnimationPlayer

func _ready():
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		visible = true
	else:
		if !OS.is_debug_build():
			visible = false

func _on_Right_pressed():
	anim.play("right")


func _on_Left_pressed():
	anim.play("left")


func _on_Down_pressed():
	anim.play("down")


func _on_Up_pressed():
	anim.play("up")

##########################################


func _on_Up_released():
	anim.play("neutral")


func _on_Right_released():
	anim.play("neutral")


func _on_Left_released():
	anim.play("neutral")


func _on_Down_released():
	anim.play("neutral")
