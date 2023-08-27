extends Node

onready var loading_scene = preload("res://scenes/loading.tscn")

func load_scene(current_scene, next_scene):
	current_scene.queue_free()
	FadeManager.reset()
	ScoreManager.reset_score(false, false, true)
	# add loading scene to the root
	var loading_scene_instance = loading_scene.instance()
	get_tree().get_root().call_deferred("add_child",loading_scene_instance)
	
	
	# find the targeted scene
	var loader = ResourceLoader.load_interactive(next_scene)
	
	#check for errors
	if loader == null:
		# handle your error
		print("error occured while getting the scene")
		return

	# creating a little delay, that lets the loading screen to appear.
	yield(get_tree().create_timer(0.5),"timeout")

	# loading the next_scene using poll() function
	# since poll() function loads data in chunks thus we need to put that in loop
	while true:
		var error = loader.poll()
		# when we get a chunk of data
		if error == OK:
			# update the progress bar according to amount of data loaded
			pass
		# when all the data have been loaded
		elif error == ERR_FILE_EOF:
			# creating scene instance from loaded data
			var scene = loader.get_resource().instance()
			# adding scene to the root
			var skin = get_tree().get_root().get_node_or_null("Skin")
			if skin:
				skin.call_deferred("free")
			MusicManager.replay_music()
			MusicManager.reset_volume()
			get_tree().get_root().call_deferred("add_child",scene)
			# removing loading scene
			loading_scene_instance.queue_free()
			FadeManager.prefadeout()
			return
		else:
			# handle your error
			print('error occurred while loading chunks of data')
			return
			
# Loading screen script taken from here: https://www.youtube.com/watch?v=5aV_GSAE1kM
