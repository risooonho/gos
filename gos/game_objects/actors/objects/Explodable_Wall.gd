extends "res://game_objects/primitive/Actor.gd"

signal exploded

func get_hit(attack):
	if attack.element == elements.elem_list.EXPLOSION:
		emit_signal("exploded")
		get_parent().queue_free()
		#play animation