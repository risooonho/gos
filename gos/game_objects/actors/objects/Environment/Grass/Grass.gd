extends Node2D

onready var is_bodyless = true
onready var z_axis = $Z_Axis
onready var actor_id = null

#func _ready():
#	var time_before = OS.get_ticks_msec()
#	var temp_material_values = $Z_Axis/Sprite.material
#	$Z_Axis/Sprite.material = null
#
#	var time = OS.get_ticks_msec() - time_before
#	print(time)

func create_particle(particle, pos):
	var instance = globals.instance_scene(globals.get_world(), particle, "Particle")
	instance.set_3d_position(pos)
	return instance


func get_3d_position():
	return Vector3(position.x, position.y, z_axis.get_z())


func get_hit(attack):
	if attack.element == elements.elem_list.NORMAL:
		var particle = create_particle("res://game_objects/particles/environment/Grass_Cut.tscn", get_3d_position())
#		get_parent().queue_free()
		$Z_Axis/Under.visible = true
		$Hurtbox.queue_free()
		$Draw_Priority_Point.position.y -= 12
		$Z_Axis/Sprite.queue_free()



func _on_Hurtbox_area_entered(area):
	if area.get_name() == "Draw_Area":
		show()


func _on_Hurtbox_area_exited(area):
	if area.get_name() == "Draw_Area":
		if !get_node("Hurtbox").is_queued_for_deletion():
			hide()


func _on_Timer_timeout():
	$Timer.queue_free()
	var pos = get_3d_position().x/24
	pos = var2str(int(pos))
	pos = pos[pos.length()-1]
	pos = float(pos) / 10
#	pos = 0.0
	$Z_Axis/Sprite.material.set_shader_param("time_offset", pos)
