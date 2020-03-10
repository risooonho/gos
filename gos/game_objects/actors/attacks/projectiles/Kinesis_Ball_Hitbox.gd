extends "res://game_objects/primitive/Hurtbox.gd"

func _on_Hurtbox_area_entered(other_area):
	if other_area.get_name() == "Hurtbox":
		var checking_body = other_area.hurtbox_owner
		if checking_body == self.hurtbox_owner.projectile_owner:
			if self.hurtbox_owner.is_returning:
				if self.hurtbox_owner.get_node("Grabber").is_holding_object():
					var grabbed_object = self.hurtbox_owner.get_node("Grabber").held_object
					self.hurtbox_owner.get_node("Grabber").release_grabbed_object()
					self.hurtbox_owner.projectile_owner.check_grabbed_object(grabbed_object)
				get_node("../Z_Axis/Sprite_Offset/Sprite").visible = false
				get_node("../Shadow_Offset").visible = false
				for child in get_node("../Z_Axis/Sprite_Offset/Particle_Emitter").get_children():
					child.stop_emitting()
					child.set_3d_position(self.hurtbox_owner.get_3d_position())
					child.queue_deletion(1)
					globals.reparent_node(child, globals.get_world())
#				get_node("../Z_Axis/Sprite_Offset/Particle_Emitter/Trail").stop_emitting()
#				get_node("../Z_Axis/Sprite_Offset/Particle_Emitter/Sparkles").stop_emitting()
#				globals.reparent_node(get_node("../Z_Axis/Sprite_Offset/Particle_Emitter/Trail"), globals.get_world()
				get_parent().get_parent().queue_free()
		else:
			if self.z_axis.check_z_collision(other_area.z_axis.get_z(), other_area.z_axis.get_top()):
				if checking_body.has_node("Grabbable"):
					if checking_body.get_node("Grabbable").is_grabbable:
						if !self.hurtbox_owner.get_node("Grabber").is_holding_object():
							self.hurtbox_owner.get_node("Grabber").grab_object(checking_body)
							globals.instance_scene(hurtbox_owner.get_node("Z_Axis/Sprite_Offset/Particle_Emitter"), "res://game_objects/particles/effects/Kinesis_Ball_Grab.tscn", "Grab")