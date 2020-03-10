extends "res://game_objects/primitive/Creature.gd"

export (PackedScene) var collision_attack

const death_time = 0.1
var dying = false
var timer = 0

func spawn_attack():
	
	# CHANGE USING GLOBAL INSTANCE SCENE
	var attack = collision_attack.instance()
	attack.set_name("Attack")
	globals.get_world().add_child(attack)
	attack.position = self.position
	var attack_direction = Vector2($'Grabbable'.thrown_direction.x, $'Grabbable'.thrown_direction.y)
	attack.init(self.z_axis.get_z(), attack_direction, stats.team, stats.attack_power)
	get_parent().queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		get_parent().queue_free()

func hit_something():
	spawn_attack()
	dying = true

func _thrown_collision_reaction(collision):
	hit_something()

func _vertical_thrown_collision_reaction():
	hit_something()

func _process(delta):
	if !dying:
		if $'Grabbable'.grabbed_state == $'Grabbable'.grabbed_states.THROWN:
			var colliding_areas = $'Hurtbox'.get_colliding_areas()
			
			for area in (colliding_areas):
				if area.get_name() == "Hurtbox" && (area.get_parent().actor_id == "Creature" || area.get_parent().actor_id == "Switch" || area.get_parent().actor_id == "Soul"):
					hit_something()
	else:
		timer +=delta
		if timer > death_time:
			get_parent().queue_free()