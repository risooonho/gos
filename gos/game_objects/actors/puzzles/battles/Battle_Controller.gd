extends Node2D

export (PackedScene) var item_to_drop = null

var origin 

func set_origin(pos):
	origin = pos

func _deactive_result():
	pass

func _active_result():
	if item_to_drop !=null:
		var dropped_item = globals.instance_scene(globals.get_world(), item_to_drop, "Battle_Spoils")
		dropped_item.get_node("Body").set_3d_position(origin)
		dropped_item.get_node("Body")._break_out(1000)
	get_parent().get_parent().queue_free()

func get_3d_position():
	return Vector3(0, 0, 0)

func set_3d_position(pos):
	pass