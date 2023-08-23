extends Node

onready var stream = $Stream
onready var extra_life = $ExtraLife

var stream_volume = 2.5

func _ready():
	stream.volume_db = stream_volume

func play_music(music):
	if not stream.stream == music:
		stream.stop()
		stream.stream = music
		stream.play()
func stop_music():
	stream.stop()

func fade_out():
	while stream.volume_db > -36:
		yield(get_tree().create_timer(0.1), "timeout")
		stream.volume_db -= 2
		if stream.volume_db < -36:
			stream.volume_db = -36
		
func fade_in():
	while stream.volume_db < stream_volume:
		yield(get_tree().create_timer(0.1), "timeout")
		stream.volume_db += 1
		if stream.volume_db > stream_volume:
			stream.volume_db = stream_volume

func extra_life_jingle():
	stream.volume_db = -36
	extra_life.play()
	while extra_life.is_playing():
		yield(get_tree().create_timer(0.1), "timeout")
	fade_in()
	
func reset_volume():
	stream.volume_db = stream_volume

func replay_music():
	stream.stop()
	stream.play()

func is_playing():
	return stream.is_playing()
