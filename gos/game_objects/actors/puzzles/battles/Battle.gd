extends "res://game_objects/primitive/Puzzle.gd"

func init_positions(position_3d, delete_this):
	var N = self.get_children()
	
	$'Battle_Controller/Body'.set_origin(delete_this.get_3d_position())
	delete_this.get_parent().queue_free()
	
	if N.size() > 1:
		for i in N:
			if i.has_node("Body"):
				var body = i.get_node("Body") 
				var body_position = body.get_3d_position()
				
				body_position += position_3d
				body.set_3d_position(body_position)