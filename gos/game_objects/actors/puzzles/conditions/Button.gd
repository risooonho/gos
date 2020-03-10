extends "res://game_objects/actors/puzzles/conditions/Switch.gd"

# Works logically with One Time Press, Hold, Timed, Trigger(Sort of)

onready var animation_player = $'AnimationPlayer'

func _activated_animation():
	animation_player.play("button_press")

func _deactivated_animation():
	animation_player.play("button_unpress")

func _physics_process(delta):
	if cooldown_timer < 10:
		cooldown_timer += delta
	
	if z_max - self.z_axis.get_top() < 2:
		if !is_held && cooldown_timer > press_cooldown:
			self.activate()
			cooldown_timer = 0
	else:
		if switch_type != switch_types.ONE_TIME_PRESS:
			if is_held && cooldown_timer > press_cooldown:
				cooldown_timer = 0
				self.deactivate()
