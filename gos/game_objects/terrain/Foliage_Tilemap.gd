extends TileMap

const foliage_path = "res://game_objects/actors/objects/Environment/Grass/Grass_Bkup2.tscn"

export (PackedScene) var foliage_scene = null
var counter = 0

var thread

onready var z_axis = get_parent()

func _ready():
	spawn_foliage()
#	thread = Thread.new()
#	thread.start(self, "spawn_foliage", "test")

func spawn_foliage():
	for cell_coords in self.get_used_cells():
		
		var cell = get_cellv(cell_coords)
		var cell_x = cell_coords.x
		
		
		var spawned_foliage = globals.instance_scene(self, foliage_scene, "Grass" + var2str(counter))
		
		var pos_to_spawn = Vector2(cell_coords.x*cell_size.x, cell_coords.y*cell_size.y)#map_to_world(cell_coords)
		pos_to_spawn.x += cell_size.x/2 + randi()%4 - 2
		pos_to_spawn.y += cell_size.y/2 - z_axis.get_z() + randi()%8 - 4
		
		spawned_foliage.get_node("Body").position = pos_to_spawn
		spawned_foliage.get_node("Body").z_axis.set_z(self.z_axis.get_z())
		spawned_foliage.get_node("Body/Z_Axis/Sprite").region_rect = tile_set.tile_get_region(cell)
		
		counter += 1
	
	clear()
	z_axis.position.y = 0