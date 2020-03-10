extends Area2D

onready var body = get_parent()

func update_collision_exceptions():
	var overlapping_bodies = []
	
	overlapping_bodies = get_overlapping_bodies()
	
	# Check for Z collision in every body in the area.
	for other_body in (overlapping_bodies):
		if other_body != self.body:
			var other_z = other_body.z_axis.get_z()
			var other_top
			if other_body.has_node("Z_Axis/Z_Height/Slope"):
				other_top = other_body.z_axis.get_top() + other_body.find_y_value(body) 
			else:
				other_top = other_body.z_axis.get_top()
			
			if !(self.body.z_axis.check_z_collision(other_z, other_top)):
				self.body.add_collision_exception_with(other_body)
			else:
				self.body.remove_collision_exception_with(other_body)