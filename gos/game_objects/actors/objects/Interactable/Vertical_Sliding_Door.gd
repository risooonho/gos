extends "res://game_objects/primitive/Actor.gd"

const dust_particles = "res://game_objects/particles/objects/Door_Open.tscn"
const door_open_height = 140

var current_anim = ""

func _ready():
	$Timer.connect("timeout", self, "_on_Timer_timeout")
	$Tween.connect("tween_completed", self, "_on_Tween_tween_completed")
	z_axis.set_z(z_axis.get_z() + door_open_height)

func _interact(player):
	$'Level_Exit'.change_level()
	door_open()

func door_open():
	globals.get_game().get_camera().shake_camera(3)
	particle_emitter.get_node("Door_Open").start_emitting()
	$Tween.interpolate_method(get_node("Z_Axis"), "set_z", z_axis.get_z(), z_axis.get_z() + door_open_height, 1.5, Tween.TRANS_CUBIC, Tween.EASE_OUT_IN)
	$Tween.start()
	current_anim = "open"

func door_close():
	$Tween.interpolate_method(get_node("Z_Axis"), "set_z", z_axis.get_z(), z_axis.get_z() - door_open_height, 0.2, Tween.TRANS_SINE, Tween.EASE_IN)
	$Tween.start()
	current_anim = "close"

func _on_Timer_timeout():
	door_close()

func _on_Tween_tween_completed(object, key):
	globals.get_game().get_camera().shake_camera(3)
	if current_anim == "open":
		particle_emitter.get_node("Door_Open").stop_emitting()