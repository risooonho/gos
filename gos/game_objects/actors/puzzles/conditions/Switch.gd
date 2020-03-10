extends "res://game_objects/primitive/Actor.gd"

const press_cooldown = 0.4
var cooldown_timer = 0

onready var condition = $'Condition'

enum switch_types {ONE_TIME_PRESS, HOLD, TIMED, TRIGGER}

export (switch_types) var switch_type = 0
export (float) var timed_timer = 0

var working = true
var timer = 0
var is_held = false

func activate():
	if working:
		is_held = true
		_activated_animation()
		match switch_type:
			switch_types.ONE_TIME_PRESS:
				condition.set_active()
			switch_types.HOLD:
				condition.set_active()
			switch_types.TIMED:
				condition.set_active()
				timer = timed_timer
			switch_types.TRIGGER:
				condition.trigger()

func deactivate():
	if working:
		match switch_type:
			switch_types.HOLD:
				condition.set_inactive()
				_deactivated_animation()
				is_held = false
			switch_types.TIMED:
				if timer <= 0:
					condition.set_inactive()
					_deactivated_animation()
					is_held = false
			switch_types.TRIGGER:
				_deactivated_animation()
				is_held = false

func _activated_animation():
	pass

func _deactivated_animation():
	pass

func _physics_process(delta):
	if working:
		if timer > 0:
			timer -= delta
			if timer <= 0:
				self.deactivate()
				timer = 0
		if switch_type == switch_types.HOLD:
			if is_held != condition.is_active():
				condition.set_state(is_held)