extends Node

export (String) var level_destination = 0
export (int) var destination_entrance = 0
export (float) var change_delay = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_level():
	globals.get_game().change_level(level_destination, destination_entrance, change_delay)
	$'Player_Transition_Animations'.player_level_transition_animation(globals.get_game().get_player())

