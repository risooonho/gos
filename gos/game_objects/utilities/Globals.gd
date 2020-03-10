extends Node

func get_system():
	return get_tree().get_root().get_node("System")

func get_game():
	return get_system().get_node("Game")

func get_ui():
	return get_game().get_node("HUD")

func get_world():
	return get_game().get_node("World")

func freeze_screen(sec):
	get_game().get_node("Screen_Freezer").freeze_screen(sec)

func clamp_value(value, min_value, max_value):
	if value < min_value:
		value = min_value
	elif value > max_value:
		value = max_value
	return value

func instance_scene(parent_node, scene_path, name_in):
	var time_before = OS.get_ticks_msec()
	var scene = scene_path	
	if scene_path is String:
		scene = load(scene_path)
	var scene_instance = scene.instance()
	scene_instance.set_name(name_in)
	parent_node.add_child(scene_instance)
	var time = OS.get_ticks_msec() - time_before
#	print(time)
	return scene_instance

func reparent_node(node, new_parent):
	node.get_parent().remove_child(node)
	new_parent.add_child(node)
	node.set_owner(new_parent)