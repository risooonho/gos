extends "res://game_objects/actors/objects/Collectible.gd"

func _ready():
	$'Small_Key_Anims'.play("animation")

func _collected():
	._collected()
	var player = globals.get_game().get_player()
	#remember to move this var to another node
	player.collect_key()