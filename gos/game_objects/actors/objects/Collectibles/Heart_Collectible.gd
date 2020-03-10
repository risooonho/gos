extends "res://game_objects/actors/objects/Collectible.gd"

func _ready():
	$'Heart_Collectible_Anims'.play("animation")

func _collected():
	._collected()
	var player = globals.get_game().get_player()
	player.deal_true_damage(-5)
	player.get_node("Effects_Animation_Player").stop()
	player.get_node("Effects_Animation_Player").play("collect_heart")
