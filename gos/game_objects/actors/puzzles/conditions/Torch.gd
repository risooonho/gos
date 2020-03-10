extends "res://game_objects/actors/puzzles/conditions/Switch.gd"

# Works logically with Hold and Timed only

func get_hit(attack):
	if !is_held:
		if attack.triggers_switches && (attack.element == elements.elem_list.FIRE):
			self.activate()
	else:
		if (attack.element == elements.elem_list.WATER) ||  (attack.element == elements.elem_list.ICE):
			self.deactivate()

func _physics_process(delta):
	var fire_collision_check = hurtbox.get_colliding_areas()
	
	for area in (fire_collision_check):
		if !is_held:
			if area.get_name() == "Hurtbox":
				if area.hurtbox_owner.actor_id == "Fireball":
					self.activate()
				if area.hurtbox_owner.actor_id == "Soul":
					if  area.hurtbox_owner.stats.element == elements.elem_list.FIRE:
						self.activate()
		else:
			#check for water
			pass