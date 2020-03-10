extends "res://game_objects/primitive/Creature.gd"

func _on_death():
	._on_death()
	get_particle_emitter().get_node("Death").start_emitting()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		create_particle("res://game_objects/particles/actors/Enemy_Disappear_Group.tscn", false, get_3d_position())
		create_particle("res://game_objects/particles/actors/Enemy_Dead.tscn", false, get_3d_position())
		get_parent().queue_free()