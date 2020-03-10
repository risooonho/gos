extends Node

var active = false

func is_active():
	return active

func trigger():
	active = not active

func set_active():
	active = true

func set_inactive():
	active = false

func set_state(value):
	active = value