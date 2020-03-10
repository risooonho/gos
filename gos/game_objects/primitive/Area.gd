extends Area2D

onready var z_axis = $'Z_Axis'
var collide_on_z = true

func get_colliding_areas():
	var overlapping_areas = get_overlapping_areas()
	var colliding_areas = []
	
	for other_area in (overlapping_areas):
		if other_area.get("collide_on_z"):
			if other_area.collide_on_z:
				if self.z_axis.check_z_collision(other_area.z_axis.get_z(), other_area.z_axis.get_top()):
					if not [other_area] in colliding_areas:
						colliding_areas.append(other_area)
	
	return colliding_areas