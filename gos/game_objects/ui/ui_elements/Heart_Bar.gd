extends Node2D

var heartbeat_normal_length = 1.1
var timer = 0

func _ready():
	$'AnimationPlayer'.play("heartbeat")

func update_values(hp, max_hp):
	$'HP_Counter'.update_value(hp, max_hp)
	
	var percent = hp/max_hp + 0.2
	if percent > 1:
		percent = 1
	
	var colors
	if percent < 0.8:
		colors = Color(1, percent - 0.1, percent - 0.1, 1)
	else:
		colors = Color(1, 1, 1, 1)
	var scale_destination = Vector2(percent, percent)
	$Tween.interpolate_property($'Fill', "scale", $'Fill'.scale, scale_destination, 0.8, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$Tween.start()
	
	var heartbeat_anim = $'AnimationPlayer'.get_animation("heartbeat")
	
	var idx = heartbeat_anim.find_track("Fill:scale")
	
	$'Fill'.modulate = colors
	$'HP_Counter'.modulate = colors
	var heartbeat_length = heartbeat_normal_length * percent
	if heartbeat_length < 0.2:
		heartbeat_length = 0.2
	heartbeat_anim.set_length(heartbeat_length)
