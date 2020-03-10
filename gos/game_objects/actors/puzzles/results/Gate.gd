extends "res://game_objects/primitive/Actor.gd"

const open_height = 150

onready var animation_Player = $'AnimationPlayer'

func _ready():
	var closed_position = Vector2(0, -z_axis.get_z())
	var open_position = Vector2(0, -z_axis.get_z() - open_height)
	
	var open_anim = animation_Player.get_animation("door_open")
	var close_anim = animation_Player.get_animation("door_close")
	
	var idx = open_anim.find_track("Z_Axis:position")
	
	open_anim.track_set_key_value(idx, 0, closed_position)
	open_anim.track_set_key_value(idx, 1, open_position)
	
	close_anim.track_set_key_value(idx, 0, open_position)
	close_anim.track_set_key_value(idx, 1, closed_position)
	
	pass

func _active_result():
	animation_Player.play("door_open")

func _deactive_result():
	animation_Player.play("door_close")