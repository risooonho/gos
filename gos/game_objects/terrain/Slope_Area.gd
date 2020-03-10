extends "res://game_objects/primitive/Physics_Body_Area.gd"

var m

func _ready():
	refresh_body_shape()
	var change_in_y = -z_axis.get_top() - (-$'Slope_Height'.position.y)
	var change_in_x =  $'Area_Shape'.shape.extents.x*2
	
	m = change_in_y / change_in_x

func find_y_value(x):
	return m * (x - (get_parent().position.x - $'Area_Shape'.shape.extents.x))