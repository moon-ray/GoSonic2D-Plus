extends Control

onready var ring_bonus_label = $RingBonuss/Label
onready var time_bonus_label = $TimeBouns/Label
onready var cool_bonus_label = $CoolBonus/Label
onready var total_label = $Total/Label
onready var anim = $AnimationPlayer
onready var player_name = $Player

var ring_bonus : int
var time_bonus : int
var cool_bonus : int
var total = 0

var tallying : bool = false

export(Texture) var sonic_name
export(Texture) var miles_name
export(Texture) var tails_name
export(Texture) var knuckles_name

export(Texture) var act_1
export(Texture) var act_2

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _process(delta):
	ring_bonus_label.text = str(ring_bonus)
	time_bonus_label.text = str(time_bonus)
	cool_bonus_label.text = str(cool_bonus)
	total_label.text = str(total)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setup_tally():
	ring_bonus = tally_rings()
	time_bonus = tally_time()
	cool_bonus = tally_cool()
	
	total = 0

func tally_total():
	tallying = true
	while ring_bonus > 0 or time_bonus > 0 or cool_bonus > 0:
		yield(get_tree().create_timer(0.02), "timeout")
		if ring_bonus > 0:
			ring_bonus -= 100
			total += 100
			ScoreManager.add_score(100)
		if time_bonus > 0:
			time_bonus -= 100
			total += 100
			ScoreManager.add_score(100)
		if cool_bonus > 0:
			cool_bonus -= 100
			total += 100
			ScoreManager.add_score(100)
		$count.play()
	$totalsound.play()
	tallying = false
		

func tally_time():
	var time_bonus : int
	
	var time = floor(ScoreManager.time)
	
	# Sonic 3 System
	
	if time == 599:
		time_bonus = 100000
	elif time <= 59:
		time_bonus = 50000
	elif time in range(60, 89):
		time_bonus = 10000
	elif time in range(90, 119):
		time_bonus = 5000
	elif time in range(120, 149):
		time_bonus = 4000
	elif time in range(150, 179):
		time_bonus = 3000
	elif time in range(180, 209):
		time_bonus = 1000
	elif time in range(210, 598):
		time_bonus = 100
		
	return time_bonus
	
func tally_rings():
	var ring_bonus = ScoreManager.rings * 100
	return ring_bonus
	
func tally_cool():
	var times_hit = ScoreManager.times_hit
	var point_table = [10000, 9000, 8000, 7000, 6000, 5000, 4000, 3000, 2000, 1000, 0]
	
	if times_hit > 10:
		times_hit = 10
		
	return point_table[times_hit]
	
func set_name_texture(texture):
	player_name.texture = texture
	
func set_player_name(player_id):
	var marker = get_node("TimeBouns/Marker")
	var marker2 = get_node("CoolBonus/Marker")
	var marker3 = get_node("RingBonuss/Marker")
	var marker4 = get_node("Total/Marker")
	match player_id:
		"Sonic":
			set_name_texture(sonic_name)
			marker.frame = 0
			marker2.frame = 0
			marker3.frame = 0
			marker4.frame = 0
		"Tails":
			set_name_texture(tails_name)
			marker.frame = 1
			marker2.frame = 1
			marker3.frame = 1
			marker4.frame = 1
		"Knuckles":
			set_name_texture(knuckles_name)
			marker.frame = 2
			marker2.frame = 2
			marker3.frame = 2
			marker4.frame = 2
func act_number(act):
	match act:
		1:
			$Through/Act.texture = act_1
		2:
			$Through/Act.texture = act_2
	
