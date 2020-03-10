extends "res://game_objects/primitive/Actor.gd"

var active = true
export (PackedScene) var battle_instance = null

func _process(delta):
	if active:
		var colliding_areas = hurtbox.get_colliding_areas()
		for area in (colliding_areas):
			if area.get_name() == "Hurtbox":
				if area.hurtbox_owner.actor_id == "Player":
					var battle = globals.instance_scene(globals.get_world(), battle_instance, "Battle")
					battle.init_positions(Vector3(self.position.x, self.position.y, self.z_min), self)
					active = false