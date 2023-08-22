extends Node2D


var loop = true

func _on_area_entered(area):
	if area.get_parent() is Player:
		loop = true
		if loop == true:
			var player = area.get_parent()
			while player.has_been_spiked == true: # To prevent 2 spikes insta killing
				yield(get_tree().create_timer(0.1), "timeout")
			if loop == true:
				player.hurt("spikes", self)



func _on_area_exited(area):
	if area.get_parent() is Player:
		loop = false
