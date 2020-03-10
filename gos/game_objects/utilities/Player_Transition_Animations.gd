extends Node

enum ANIMATION_DIRECTIONS {NONE, LEFT, RIGHT, UP, DOWN}
enum LEVEL_TRANSITION_ANIMATIONS {NONE, WALK, DOOR}
export (LEVEL_TRANSITION_ANIMATIONS) var animation = 0
export (ANIMATION_DIRECTIONS) var direction = 0

func player_level_transition_animation(player):
	player.stop_movement()
	var dir = Vector3(0, 0, 0)
	match direction:
		ANIMATION_DIRECTIONS.NONE:
			dir = Vector3(0, 0, 0)
		ANIMATION_DIRECTIONS.LEFT:
			dir = Vector3(-1, 0, 0)
		ANIMATION_DIRECTIONS.RIGHT:
			dir = Vector3(1, 0, 0)
		ANIMATION_DIRECTIONS.UP:
			dir = Vector3(0, -1, 0)
		ANIMATION_DIRECTIONS.DOWN:
			dir = Vector3(0, 1, 0)
	
	match animation:
		LEVEL_TRANSITION_ANIMATIONS.NONE:
			player.stop_movement()
		LEVEL_TRANSITION_ANIMATIONS.WALK:
			player.move_direction = dir
		LEVEL_TRANSITION_ANIMATIONS.DOOR:
			yield(get_tree().create_timer(1.5), "timeout")
			player.move_direction = dir
