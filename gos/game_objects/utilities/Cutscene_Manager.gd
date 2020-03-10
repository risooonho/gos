# Universal Cutscenes:
# 0001 - Talk with NPC, NPC keeps look direction
# 0002 - Talk with NPC, NPC faces you
# 0003 - Non-Dialogue Message

extends Node

onready var room_controller = get_parent()

func play_cutscene(cutscene_id):
	if current_cutscene():
		current_cutscene().queue_free()
	var file_path = "res://game_objects/resources/cutscenes/"
	file_path += "Cutscene_" + cutscene_id + ".tscn"
	
	var cutscene_script = load(file_path)
	var cutscene_script_instance = cutscene_script.instance()
	self.add_child(cutscene_script_instance)
	cutscene_script_instance.set_name("Current_Cutscene")
	
	globals.get_ui().cutscene_start_animations()
	globals.get_game().get_player().move_direction = Vector3(0, 0, 0)
	globals.get_game().get_player().control_disabled = true
	#load actors
	#load cutscene script

func current_cutscene():
	if self.has_node("Current_Cutscene"):
		return $'Current_Cutscene'

func _process(delta):
	pass

func end_cutscene():
	globals.get_ui().cutscene_end_animations()
	globals.get_game().get_camera().set_following_actor(weakref(globals.get_game().get_player()))
	globals.get_game().get_player().control_disabled = false

