extends KinematicBody2D

enum z_states {GROUNDED, AIRBORNE}

onready var particle_emitter = $'Z_Axis/Sprite_Offset/Particle_Emitter'
onready var z_axis = $'Z_Axis'
onready var hurtbox = $'Hurtbox'

var z_state = null
var previous_frame_z_state = null
var velocity = Vector3(0, 0, 0)
var net_force = Vector3(0, 0, 0)
var init_counter = 0
var z_min = 0
var z_max = 99999
var affected_by_gravity = true
var react_on_wall_collision = false

onready var move_direction = Vector3(0, 0, 0)

export (bool) var stationary = false
export (String) var actor_id = "default"
export (bool) var heavy
export (float) var move_speed = 0
export (float) var gravity_force = 0
export (Vector3) var terminal_velocity = Vector3(3000, 3000, -2000)
export (float) var ground_acceleration = 0
export (float) var ground_friction = 0
export (float) var air_acceleration = 0
export (float) var air_friction = 0
export (float) var bounciness = 0.3

signal actor_jumped
signal actor_landed

func _ready():
	$'Body_Shape'.disabled = true

func get_xy_velocity():
	return Vector2(velocity.x, velocity.y)

func create_particle(particle, local, pos):
	var parent = null
	if local:
		parent = self.get_node("Z_Axis/Sprite_Offset/Particle_Emitter")
	else:
		parent = globals.get_world()
	
	var instance = globals.instance_scene(parent, particle, "Particle")
	instance.set_3d_position(pos)
	return instance

func get_sprite_offset():
	return z_axis.get_node("Sprite_Offset")

func get_particle_emitter():
	return get_sprite_offset().get_node("Particle_Emitter")

func get_z_velocity():
	return velocity.z

func add_force(force):
	net_force += force

func apply_impulse(force):
	velocity += force

func stop_movement():
	move_direction = Vector3(0, 0, 0)
	velocity = Vector3(0, 0, 0)
	net_force = Vector3(0, 0, 0)

func get_3d_position():
	return Vector3(position.x, position.y, z_axis.get_z())

func set_3d_position(position_in):
	position = Vector2(position_in.x, position_in.y)
	z_axis.change_z(position_in.z)

func get_direction_to_point(point):
	return Vector3(point.x - self.position.x, point.y - self.position.y, point.z - self.z_axis.get_z()).normalized()

func get_direction_to_point_xy(point):
	return Vector2(point.x - self.position.x, point.y - self.position.y).normalized()

func get_direction_to_point_z(point):
	var direction = -1
	if point > z_axis.get_z():
		direction = 1
	return direction

func _thrown_collision_reaction(collision):
	var new_xy_velocity = -get_xy_velocity()*bounciness
	
	velocity.x = new_xy_velocity.x
	velocity.y = new_xy_velocity.y

func _vertical_thrown_collision_reaction():
	velocity.z = -(velocity.z*bounciness)

func _actor_specific_wall_reaction(collision):
	pass

func _physics_process(delta):
	if init_counter != -1:
		if init_counter < 0.05:
			init_counter+=delta
		else:
			$'Body_Shape'.disabled = false
			init_counter = -1
	
	move_direction = move_direction.normalized()
	add_force(move_direction * move_speed)
	# update z_min and z_max
	var z_min_change = 0
	var z_max_change = 99999
	var overlapping_areas = $'Body_Area'.get_overlapping_areas()
	
	for area in (overlapping_areas):
		if area.get_name() == "Body_Area":
			var checking_body = area.get_parent()
			
			for i in range (20):
				if checking_body.get_collision_layer_bit(i):
					if self.get_collision_mask_bit(i):
						var other_z = checking_body.z_axis.get_z()
						var other_z_top
						if checking_body.has_node("Z_Axis/Z_Height/Slope"):
							other_z_top = checking_body.z_axis.get_top() + checking_body.find_y_value(self)
						else:
							other_z_top = checking_body.z_axis.get_top()
						
						if self.z_axis.get_z() >= other_z_top:
							if other_z_top> z_min_change:
								z_min_change = other_z_top
						elif self.z_axis.get_top() <= other_z:
							if other_z < z_max_change: 
								z_max_change = other_z
						
#						if checking_body.has_node("Slope"):
#							z_min_change += checking_body.find_y_value(self)
					break
	
	z_min = z_min_change
	z_max = z_max_change
	
	var xy_velocity = get_xy_velocity()
	var z_velocity = velocity.z
	
	var friction_to_use = ""
	if z_state == z_states.GROUNDED:
		friction_to_use += "ground_"
	else:
		friction_to_use += "air_"
	if net_force == Vector3(0, 0, 0):
		friction_to_use += "friction"
	else:
		friction_to_use += "acceleration"
#	if z_state == z_states.GROUNDED:
	xy_velocity += ((Vector2(net_force.x, net_force.y))-xy_velocity) * get(friction_to_use) * delta
#	else:
#		xy_velocity += ((Vector2(net_force.x, net_force.y))-xy_velocity) * air_friction * delta
	
	if !affected_by_gravity || gravity_force == 0:
		z_velocity += (net_force.z - z_velocity) * get(friction_to_use) * delta
	else:
		z_velocity += (terminal_velocity.z - z_velocity) * gravity_force * delta
	
	velocity = Vector3(xy_velocity.x, xy_velocity.y, z_velocity)
	
	if !stationary:
		if react_on_wall_collision:
			var collision_checker = move_and_collide(get_xy_velocity()*delta)
			if collision_checker:
				_thrown_collision_reaction(collision_checker)
		else:
			var collision_checker = move_and_slide(get_xy_velocity())
			if get_slide_count() > 0 :
				_actor_specific_wall_reaction(get_slide_collision(0))
	
	z_axis.change_z(velocity.z*delta)
	
	
	if z_axis.get_z() <= z_min + 1:
		z_axis.set_z(z_min + 1)
		if react_on_wall_collision:
			_vertical_thrown_collision_reaction()
		else:
			velocity.z = 0
			z_state = z_states.GROUNDED
	else:
		z_state = z_states.AIRBORNE
	
	
	
	if previous_frame_z_state != z_state:
		if previous_frame_z_state != null:
			if previous_frame_z_state == z_states.GROUNDED:
				emit_signal("actor_jumped")
				print("jumped")
			elif previous_frame_z_state == z_states.AIRBORNE:
				emit_signal("actor_landed")
				print("landed")
	
	previous_frame_z_state = z_state
	
	if z_axis.get_top() >= z_max - 1:
		z_axis.set_z(z_max - 1 - z_axis.get_height())
		if react_on_wall_collision:
			_vertical_thrown_collision_reaction()
		else:
			velocity.z = 0
	
	get_node("Z_Axis_Detector").update_collision_exceptions()
	if has_node("Hurtbox"):
		$Hurtbox.update_z()
	
	net_force = Vector3(0, 0, 0)