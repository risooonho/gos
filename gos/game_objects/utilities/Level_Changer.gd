extends "res://game_objects/primitive/Area.gd"

var exit_triggered = false

func _ready():
	exit_triggered = false

func _physics_process(delta):
	if exit_triggered == false:
		var colliding_areas = get_colliding_areas()
			
		for area in (colliding_areas):
			if area.get_name() == "Hurtbox":
				if area.hurtbox_owner.actor_id == "Player":
					$'Level_Exit'.change_level()
					exit_triggered = true