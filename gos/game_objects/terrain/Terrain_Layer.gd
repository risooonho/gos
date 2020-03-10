extends TileMap

const terrain_path = "res://game_objects/primitive/Terrain.tscn"

onready var z_axis = get_parent()

# make the tilemap and name the tiles appropriately: top, and mid
#
# in the editor, have a simple tilemap of those, with a z-axis node attached. the tilemaps script will, at runtime:
# check whether a tile is a "top" tile
#
#it will then scan all the tiles below it. if the below tile is a "top" tile, it will ignore it and add 1 to a "top tile counter",
# then continue scanning below
#
#if it's a "mid" tile, it will add to the "mid tile counter". At the first "mid" tile found, 
#it will check the "top tile counter"
#and if it's 0, then that makes this tile an "edge". Any "top" tile after that is just ignored, not added to a counter
#
#When the scanning cell finds an a tile other than top or mid, or is empty, it stops checking
#it then creates a 1x1 (on the grid) terrain object at the tilemap's (position - z_axis), and tile map's z-axis, 
#setting the height to "middle tile counter" * cell size.
#the top sprite that will be used for that terrain object will be taken from the cell. 
#if we cant take sprite directly from the tilemap, we'll use trhe same 
#texture + region as the tilemap's cell. 
#if it was found to be an "edge" tile, then...

func get_tile_name_prefix(name_in):
	return name_in.substr(0, 3)

func _ready():
	#visible = false
	for cell_coords in self.get_used_cells():
		
		var cell = get_cellv(cell_coords)
		var cell_name = tile_set.tile_get_name(cell)
		cell_name = get_tile_name_prefix(cell_name)
		
		if cell_name == "top":
			
			var top_tile_counter = 0
			var mid_tile_counter = 0
			var keep_checking = true
			var tile_y_offset = 1
			var is_edge = false
			var mid_cell_array = []
			
			while keep_checking == true:
				var below_tile = get_cellv(Vector2(cell_coords.x, cell_coords.y + tile_y_offset))
				var below_tile_name = tile_set.tile_get_name(below_tile)
				below_tile_name = get_tile_name_prefix(below_tile_name)
				if below_tile_name == "top":
					
					if !is_edge:
						
						top_tile_counter += 1
						
				elif below_tile_name == "mid":
					
					if !is_edge:
						
						if top_tile_counter == 0:
							
							is_edge = true
					
					if is_edge:
						mid_cell_array.append(below_tile)
					mid_tile_counter += 1
					
				else:
					
					below_tile_name = "null"
					keep_checking = false
					
				tile_y_offset += 1
				
			var height =  mid_tile_counter * cell_size.y
			var spawned_terrain = globals.instance_scene(self, terrain_path, "Block")
			var pos_to_spawn = map_to_world(cell_coords)
			pos_to_spawn.x += cell_size.x/2
			pos_to_spawn.y += cell_size.y/2 - z_axis.get_z() + height
			
			spawned_terrain.get_node("Body").position = pos_to_spawn
			spawned_terrain.get_node("Body/Body_Shape").shape.extents = Vector2(cell_size.x/2, cell_size.y/2)
			spawned_terrain.get_node("Body").z_axis.set_z(self.z_axis.get_z())
			spawned_terrain.get_node("Body").z_axis.set_height(height)
			spawned_terrain.get_node("Body/Z_Axis/Z_Height/Top").texture = tile_set.tile_get_texture(cell)
			spawned_terrain.get_node("Body/Z_Axis/Z_Height/Top").region_enabled = true
			spawned_terrain.get_node("Body/Z_Axis/Z_Height/Top").region_rect = tile_set.tile_get_region(cell)
			
			if is_edge:
				var cell_y = 0
				var mid_tilemap = spawned_terrain.get_node("Body/Z_Axis/Middle")
				mid_tilemap.set_tileset(self.get_tileset())
				for tile_id in mid_cell_array:
					mid_tilemap.set_cell(-1, cell_y - mid_cell_array.size(), tile_id)
					cell_y += 1
			
			#print(spawned_terrain.position)
	clear()
	z_axis.position.y = 0