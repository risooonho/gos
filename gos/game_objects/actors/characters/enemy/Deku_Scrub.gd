extends "res://game_objects/actors/characters/enemy/Basic_Enemy.gd"

onready var projectile = load("res://game_objects/actors/attacks/projectiles/Deku_Seed.tscn")
onready var proximity_area = $'Shoot_Proximity'
onready var hide_proximity_area = $'Hide_Proximity'

const shoot_frequency = 1.4

var hidden = true
var shoot_timer = 0
var player_within_range = false
var player_within_hide_range = false

func hide():
	visible = false
	hurtbox.get_node("Area_Shape").disabled = true
	set_collision_layer_bit(2, false)
	hidden = true

func pop_out():
	visible = true
	shoot_timer = 0
	hurtbox.get_node("Area_Shape").disabled = false
	set_collision_layer_bit(2, true)
	hidden = false

func _process(delta):
	if stats.is_alive():
		player_within_range = false
		player_within_hide_range = false
		
		var colliding_areas = proximity_area.get_colliding_areas()
		
		for area in (colliding_areas):
			if area.get_name() == "Hurtbox":
				if area.hurtbox_owner.actor_id == "Player":
					player_within_range = true
		
		colliding_areas = hide_proximity_area.get_colliding_areas()
		
		for area in (colliding_areas):
			if area.get_name() == "Hurtbox":
				if area.hurtbox_owner.actor_id == "Player":
					player_within_hide_range = true
		
		if !player_within_range:
			hide()
		if player_within_range && hidden:
			pop_out()
		if player_within_hide_range && !hidden:
			hide()
		
		if !hidden:
			shoot_timer += delta
			if shoot_timer > shoot_frequency:
				shoot_timer = 0
				var projectile_instance = globals.instance_scene(get_parent() ,projectile, "Deku_Seed")
				projectile_instance.get_node("Body").init(get_direction_to_point(globals.get_game().get_player().get_3d_position()))