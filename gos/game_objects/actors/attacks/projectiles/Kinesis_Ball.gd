extends "res://game_objects/primitive/Actor.gd"

const return_delay = 0.15
const floating_height = 35
var timer = 0
var is_returning = false
var projectile_owner

func _ready():
	projectile_owner = $'../../Body'
	$AnimationPlayer.play("glow")
	position = projectile_owner.position
	z_axis.set_z(projectile_owner.z_axis.get_z()+floating_height)

func init(direction):
	move_direction = direction.normalized()
	move_direction.z = 0

func _process(delta):
	timer+=delta
	if timer > return_delay:
		is_returning = true
		move_direction = get_direction_to_point(Vector3(projectile_owner.position.x, projectile_owner.position.y, projectile_owner.z_axis.get_z()+floating_height))