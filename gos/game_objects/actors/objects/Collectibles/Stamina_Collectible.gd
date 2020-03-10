extends "res://game_objects/actors/objects/Collectible.gd"

func _ready():
	$'Stamina_Collectible_Anims'.play("glow")

func _collected():
	._collected()
	var player = globals.get_game().get_player()
	player.stats.deplete_or_replenish_stamina(50)
	player.get_node("Effects_Animation_Player").stop()
	player.get_node("Effects_Animation_Player").play("collect_stamina")