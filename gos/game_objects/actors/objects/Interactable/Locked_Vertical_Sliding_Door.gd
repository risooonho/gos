extends "res://game_objects/actors/objects/Interactable/Vertical_Sliding_Door.gd"

var locked = true

func _interact(player):
	if player.small_keys > 0:
		player.use_key()
		locked = false
		._interact(player)