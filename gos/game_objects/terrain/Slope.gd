extends "res://game_objects/primitive/Terrain.gd"

enum SLOPE_DIRECTIONS {RIGHT, LEFT, UP, DOWN}

export (SLOPE_DIRECTIONS) var slope_direction = 0
var m 

func _ready():
	var change_in_y = (z_axis.get_top() + (-$'Z_Axis/Z_Height/Slope'.position.y)) - z_axis.get_top() 
	var change_in_x =  $'Body_Shape'.shape.extents.x*2
	match slope_direction:
		SLOPE_DIRECTIONS.RIGHT:
			change_in_x = $'Body_Shape'.shape.extents.x*2
		SLOPE_DIRECTIONS.LEFT:
			change_in_x = -$'Body_Shape'.shape.extents.x*2
		SLOPE_DIRECTIONS.DOWN:
			change_in_x = $'Body_Shape'.shape.extents.y*2
		SLOPE_DIRECTIONS.UP:
			change_in_x = -$'Body_Shape'.shape.extents.y*2
	
	m = change_in_y / change_in_x

func find_y_value(other):
	var other_x
	var x
	match slope_direction:
		SLOPE_DIRECTIONS.RIGHT:
			other_x = other.position.x+other.get_node("Body_Area/Area_Shape").shape.extents.x
			x = position.x - $'Body_Shape'.shape.extents.x
		SLOPE_DIRECTIONS.LEFT:
			other_x = other.position.x-other.get_node("Body_Area/Area_Shape").shape.extents.x
			x = position.x + $'Body_Shape'.shape.extents.x
		SLOPE_DIRECTIONS.DOWN:
			other_x = other.position.y+other.get_node("Body_Area/Area_Shape").shape.extents.y
			x = position.y - $'Body_Shape'.shape.extents.y
		SLOPE_DIRECTIONS.UP:
			other_x = other.position.y-other.get_node("Body_Area/Area_Shape").shape.extents.y
			x = position.y + $'Body_Shape'.shape.extents.y
	
	var x_on_line = other_x - x
	var returner = m * x_on_line
	returner = globals.clamp_value(returner, 0, -$'Z_Axis/Z_Height/Slope'.position.y)
	return returner
