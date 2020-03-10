extends "res://game_objects/primitive/Actor.gd"

var chase_player = false
const chase_height = 16

func _ready():
	affected_by_gravity = true
	react_on_wall_collision = true

func _break_out(force):
	apply_impulse(Vector3(0, 0, force))

func _collected():
	get_parent().queue_free()

func _physics_process(delta):
	if !chase_player:
		var colliding_areas = hurtbox.get_colliding_areas()
			
		for area in (colliding_areas):
			if area.get_name() == "Hurtbox":
				if area.hurtbox_owner.actor_id == "Player":
					$'AnimationPlayer'.play("shrink")
					chase_player = true
					affected_by_gravity = false
		
	else:
		var player_direction = globals.get_game().get_player().get_3d_position()
		move_direction = get_direction_to_point(Vector3(player_direction.x, player_direction.y, player_direction.z + chase_height))