extends Node2D

onready var particle_systems = get_node("Z_Axis").get_children()

func _ready():
	for particle_system in particle_systems:
		if particle_system is Position2D:
			particle_systems.erase(particle_system)
	update_position()

func update_position():
	for y in particle_systems:
		y.position += self.position
		y.z_axis.change_z($Z_Axis.get_z())
	
	self.position = Vector2(0,0)
	$Z_Axis.set_z(0)

func start_emitting():
	for particle_system in particle_systems:
		particle_system.start_emitting()

func stop_emitting():
	for particle_system in particle_systems:
		particle_system.stop_emitting()

func queue_deletion(sec):
	for particle_system in particle_systems:
		particle_system.queue_deletion(sec)


func set_color_all(color_in):
	for particle_system in particle_systems:
		particle_system.set_color_all(color_in)


func set_3d_position(pos):
	position = Vector2(pos.x, pos.y)
	$Z_Axis.set_z(pos.z)
	update_position()