extends Node

onready var body = get_parent()
var active = false
export (bool) var invert_outcome = false

func get_active_state():
	return active

func set_active_state(value):
	active = value
	if invert_outcome:
		value = not value
	if value:
		body._active_result()
	else:
		body._deactive_result()
