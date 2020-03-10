extends StaticBody2D

onready var z_axis = $'Z_Axis'

func get_3d_position():
	return Vector3(position.x, position.y, z_axis.get_z())

func set_3d_position(position_in):
	position = Vector2(position_in.x, position_in.y)
	z_axis.change_z(position_in.z)