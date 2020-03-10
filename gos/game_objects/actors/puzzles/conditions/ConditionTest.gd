extends "res://game_objects/primitive/Actor.gd"

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 3 && event.pressed:
			get_node("Condition").trigger()
