extends "res://game_objects/actors/characters/soul/Soul.gd"

export (float) var fuse_time = 0 

var fuse_is_on = false
var bomb_timer = 0
var bomb_timer_string = ""

func _on_death():
	globals.get_game().get_camera().shake_camera(3)
#	create_particle("res://game_objects/particles/objects/Explosion_Group.tscn", false, get_3d_position())
	hit_something()

func _ready():
	affected_by_gravity = false

func hit_something():
	create_particle("res://game_objects/particles/objects/Explosion_Group.tscn", false, get_3d_position())
	.hit_something()

func start_timer():
	bomb_timer = fuse_time

func _thrown_collision_reaction(collision):
	stop_movement()
	$'Grabbable'.set_free()
	affected_by_gravity = true

func _vertical_thrown_collision_reaction():
	stop_movement()
	$'Grabbable'.set_free()
	affected_by_gravity = true

func _physics_process(delta):
	if fuse_is_on:
		bomb_timer -= delta
		print(bomb_timer)
		bomb_timer_string = var2str(round(bomb_timer))
		if bomb_timer <= 0:
			self.stats.take_or_heal_damage(1)
#			globals.get_game().get_camera().shake(0.3, 50, 15)
	else:
		if $'Grabbable'.grabbed_state == $'Grabbable'.grabbed_states.GRABBED:
			start_timer()
			fuse_is_on = true
