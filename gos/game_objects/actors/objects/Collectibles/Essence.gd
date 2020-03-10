extends "res://game_objects/actors/objects/Collectible.gd"

enum COLORS {GREEN, RED, PINK, PURPLE, BLUE, CYAN}

export (COLORS) var essence_color = 0
const values = [1, 5, 20, 50, 100, 300]

func _collected():
	._collected()
	var player = globals.get_game().get_player()
	player.collect_or_spend_essence(values[essence_color])
#	player.get_node("Effects_Animation_Player").stop()
#	player.get_node("Effects_Animation_Player").play("collect_heart")