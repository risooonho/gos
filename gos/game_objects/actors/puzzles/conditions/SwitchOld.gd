extends "res://game_objects/primitive/Actor.gd"

onready var condition = $'Condition'

enum switch_types {ONE_TIME_PRESS, HOLD, TIMED, TRIGGER}

export (switch_types) var switch_type = 0
export (float) var timed_timer = 0

var timer = 0
var is_held = false

func activate():
	is_held = true
	if switch_type == TRIGGER:
		condition.trigger()
	else:
		if switch_type == TIMED:
			timer = timed_timer
		if switch_type != HOLD:
			condition.set_active()

func deactivate():
	is_held = false
	if switch_type != TRIGGER && switch_type != ONE_TIME_PRESS:
		condition.set_inactive()

func _physics_process(delta):
	if timer > 0:
		timer -= delta
		print(timer)
		if timer <= 0:
			self.deactivate()
			timer = 0
	if switch_type == HOLD:
		if is_held != condition.is_active():
			condition.set_state(is_held)