extends "res://game_objects/actors/puzzles/conditions/Switch.gd"

func _interact(player):
	if !is_held:
		activate()
	else:
		deactivate()

