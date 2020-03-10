extends Node

enum grabbed_states {FREE, GRABBED, THROWN}

onready var grabbable_object = get_parent()

var grabbed_state = 0
var is_grabbable = true
var thrown_direction = Vector3(0, 0, 0)

export (float) var thrown_force = 0
export (bool) var gravity_when_thrown = false

func set_grabbed():
	grabbed_state = grabbed_states.GRABBED
	grabbable_object.get_node("Body_Shape").call_deferred("disabled", true)
	if not grabbable_object.get("invulnerability") == null:
		grabbable_object.invulnerability = true
	grabbable_object.stop_movement()
	if grabbable_object.get("move_direction"):
		grabbable_object.move_direction = Vector3(0, 0, 0)
	grabbable_object.affected_by_gravity = false
	thrown_direction = Vector3(0, 0, 0)
	is_grabbable = false

func set_free():
	grabbed_state = grabbed_states.FREE
	grabbable_object.get_node("Body_Shape").call_deferred("disabled", false)
	if not grabbable_object.get("invulnerability") == null:
		grabbable_object.invulnerability = false
	thrown_direction = Vector3(0, 0, 0)
	grabbable_object.affected_by_gravity = true
	grabbable_object.react_on_wall_collision = false
	is_grabbable = true
	

func set_thrown(direction):
	grabbed_state = grabbed_states.THROWN
	thrown_direction = direction
	grabbable_object.apply_impulse(thrown_direction*thrown_force)
	grabbable_object.affected_by_gravity = gravity_when_thrown
	if not grabbable_object.get("invulnerability") == null:
		grabbable_object.invulnerability = false
	grabbable_object.react_on_wall_collision = true
	grabbable_object.get_node("Body_Shape").call_deferred("disabled", false)

func _physics_process(delta):
	if grabbed_state == grabbed_states.THROWN:
		grabbable_object.add_force(thrown_direction.normalized()*thrown_force)
