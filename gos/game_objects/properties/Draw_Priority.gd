extends Node

enum DRAW_PRIORITY_SETTING {FRONT, BACK, UI}

export (DRAW_PRIORITY_SETTING) var priority_setting = 0

onready var body = get_parent()

func _process(delta):
	var new_z_index = 0
	if body.get("is_bodyless"):
		new_z_index = body.position.y + body.get_node("Draw_Priority_Point").position.y
	else:
		if priority_setting == DRAW_PRIORITY_SETTING.FRONT:
			new_z_index = body.position.y + body.get_node("Body_Shape").shape.extents.y# + body.z_axis.get_z()
		elif priority_setting == DRAW_PRIORITY_SETTING.BACK:
	#		new_z_index = body.position.y + body.get_node("Body_Shape").shape.extents.y# + body.z_axis.get_z()
			new_z_index = body.position.y - body.get_node("Body_Shape").shape.extents.y# + body.z_axis.get_z()
		elif priority_setting == DRAW_PRIORITY_SETTING.UI:
			new_z_index = 4096
	
#	if body.has_node("Shadow_Offset"):
#		body.get_node("Shadow_Offset").set_z_index(-(body.z_axis.get_z() - body.z_min))
	
#	if body.has_node("Shadow_Offset") && body is StaticBody2D:
#		body.get_node("Shadow_Offset").set_z_index(4096)
	new_z_index = globals.clamp_value(new_z_index, -4096, 4096)
	body.set_z_index(new_z_index)