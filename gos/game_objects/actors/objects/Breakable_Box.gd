extends "res://game_objects/primitive/Grabbable_Actor.gd"

export (PackedScene) var contained_item = null

func break_box():
	if contained_item!= null:
		var spawned_item = globals.instance_scene(globals.get_world(), contained_item, "Collectible")
		spawned_item.get_node("Body").set_3d_position(get_3d_position())
		spawned_item.get_node("Body")._break_out(700)
	#spawn broken particles
	get_parent().queue_free()

func get_hit(attack):
	break_box()

func _thrown_collision_reaction(collision):
	._thrown_collision_reaction(collision)
	break_box()

func _vertical_thrown_collision_reaction():
	._vertical_thrown_collision_reaction()
	break_box()
