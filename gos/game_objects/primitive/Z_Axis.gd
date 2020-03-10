extends Position2D

onready var height = $'Z_Height'

func get_z():
	return -position.y

func change_z(value):
	position.y -= value

func set_z(value):
	position.y = -value

func get_height():
	return -height.position.y

func change_height(value):
	height.position.y -= value

func set_height(value):
	height.position.y = -value

func get_top():
	return -(self.position.y) + -(height.position.y)

func check_z_collision(other_z, other_top):
	if self.get_top() >= other_z && other_top >= self.get_z():
		return true
	else:
		return false