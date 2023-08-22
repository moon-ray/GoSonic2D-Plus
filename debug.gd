extends Sprite

func _process(delta):
	global_position = get_parent().get_node("StaticBody2D").global_position
