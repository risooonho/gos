extends Node

onready var self_body = get_node("..")

var held_object = null
var held_object_weakref = null

func is_holding_object():
	if held_object != null:
		return true
	return false

func grab_object(object):
	held_object = object
	held_object_weakref = weakref(object)
	held_object.get_node("Grabbable").set_grabbed()

func release_grabbed_object():
	held_object.get_node("Grabbable").set_free()
	held_object = null
	held_object_weakref = null

func throw_grabbed_object(throw_direction):
	held_object.get_node("Grabbable").set_thrown(throw_direction)
	held_object = null
	held_object_weakref = null

func get_grab_offset():
	return Vector3($'XY_Offset'.position.x, $'XY_Offset'.position.y, -$'XY_Offset/Z_Offset'.position.y)

func _process(delta):
	if is_holding_object():
		if !held_object_weakref.get_ref():
			held_object = null
			held_object_weakref = null
		else:
			held_object.position = self_body.position + Vector2(get_grab_offset().x, get_grab_offset().y)
			held_object.z_axis.set_z(self_body.z_axis.get_z() + get_grab_offset().z)