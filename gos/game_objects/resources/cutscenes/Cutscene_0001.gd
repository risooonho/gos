extends "res://game_objects/resources/cutscenes/Cutscene.gd"

func _ready():
	play_dialogue("0001")

func _on_Dialogue_Ended():
	cutscene_manager.end_cutscene()