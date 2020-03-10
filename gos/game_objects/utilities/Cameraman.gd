extends "res://game_objects/utilities/Shakey_Camera.gd"

var following_actor = null

func _process(delta):
	if following_actor != null:
		if following_actor.get_ref():
			self.position.x = following_actor.get_ref().position.x
			self.position.y = following_actor.get_ref().position.y - following_actor.get_ref().z_axis.get_z()

func set_following_actor(actor):
	following_actor = actor

func unfollow_actor():
	following_actor = null