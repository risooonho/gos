extends "res://game_objects/primitive/Position25D.gd"

func player_entrance_animation(player):
	player.position = self.position
	player.z_axis.set_z(self.z_axis.get_z())
	$'Player_Transition_Animations'.player_level_transition_animation(player)