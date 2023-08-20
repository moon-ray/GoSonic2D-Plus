extends Label

func _process(delta):
	set_text(get_parent().get_parent().name)
