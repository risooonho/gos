extends "res://game_objects/primitive/Actor.gd"

const burn_time = 5
var on_fire = false

var timer = 0

func get_hit(attack):
	if !on_fire:
		if attack.element == elements.elem_list.FIRE:
			on_fire = true
			#play animation

func _physics_process(delta):
	if on_fire:
		timer += delta
		if timer > burn_time:
			get_parent().queue_free()