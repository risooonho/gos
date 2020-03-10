extends "res://game_objects/primitive/Creature.gd"

export (bool) var invulnerable = true
export (String) var dialogue_id

func _ready():
	invulnerability = invulnerable

func _interact(player):
	globals.get_game().play_cutscene(dialogue_id)
	globals.get_game().cutscene_manager.current_cutscene().add_actor(self)