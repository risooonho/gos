extends Node

onready var hud = $'HUD'
onready var world = $'World'
onready var cutscene_manager = $'Cutscene_Manager'

func get_camera():
	return $'Cameraman/Camera2D'

func _ready():
	hud.fade.fade_in()
	hud.check_level_name_change(world.level_name)
	get_camera().set_following_actor(weakref(get_player()))

func play_cutscene(cutscene_id):
	cutscene_manager.play_cutscene(cutscene_id)

func get_player():
	return get_node("Player/Body")

func game_over():
	globals.instance_scene(hud, "res://game_objects/ui/game_over/Game_Over.tscn", "Game_Over")

func change_level(level_number, entrance_number, change_delay):
	var level_path = "res://game_objects/rooms/"
	level_path += "Level_" + level_number + ".tscn"
	
	get_player().control_disabled = true
	hud.cutscene_start_animations()
	var current_level = world
	yield(get_tree().create_timer(change_delay), "timeout")
	hud.fade.fade_out()
	yield(hud.fade, "faded_out")
	
	self.remove_child(current_level)
	current_level.call_deferred("free")
	
	world = globals.instance_scene(self, level_path, "World")
	var entrance_node = world.get_node("Level_Entrance" + var2str(entrance_number))
#	if world.has_node(entrance_node):
	entrance_node.player_entrance_animation(get_player())
	hud.fade.fade_in()
	yield(hud.fade, "faded_in")
	hud.cutscene_end_animations()
	hud.check_level_name_change(world.level_name)
	get_player().control_disabled = false
	#scene changed signal

func _on_Bomb_Exploded():
	pass
#	get_camera().shake_camera(3)