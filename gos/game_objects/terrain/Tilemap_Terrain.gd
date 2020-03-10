extends "res://game_objects/primitive/Terrain.gd"

var only_once = false

func _ready():
	var tilemap = $Z_Axis/Z_Height/Top
	#pass#	for tile_shape in $Z_Axis/Z_Height/Top.tile_set.tile_get_shapes(
	for cell_coords in tilemap.get_used_cells():
		var tile_shape = tilemap.tile_set.tile_get_shape(tilemap.get_cellv(cell_coords), 0)
		print("how many shrimps")
		if !only_once:
			var new_shape = CollisionShape2D.new()
			new_shape.shape = tile_shape
			new_shape.set_name("Bodyshape")
			self.add_child(new_shape)
			var new_area = Area2D.new()
			new_area.add_child(new_shape)
			self.add_child(new_area)
			only_once = true
		#create a new collisionshape2d with that shape, add it to staticbody2d and area2d

