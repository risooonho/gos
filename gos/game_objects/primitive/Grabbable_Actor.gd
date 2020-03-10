extends "res://game_objects/primitive/Actor.gd"

export (PackedScene) var impact_attack

func spawn_impact_attack():
	
	if impact_attack != null:
		var attack_instance = impact_attack.instance()
		attack_instance.set_name("Attack")
		get_parent().get_parent().add_child(attack_instance)
		attack_instance.position = self.position
		attack_instance.init(self.z_axis.get_z(), Vector2($'Grabbable'.thrown_direction.x,$'Grabbable'.thrown_direction.y), 0, 0)

func _thrown_collision_reaction(collision):
	._thrown_collision_reaction(collision)
	spawn_impact_attack()
	$'Grabbable'.set_free()
	affected_by_gravity = true

func _vertical_thrown_collision_reaction():
	._vertical_thrown_collision_reaction()
	spawn_impact_attack()
	$'Grabbable'.set_free()
	affected_by_gravity = true