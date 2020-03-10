extends Node

export (float) var normal = 1
export (float) var fire = 1
export (float) var water = 1
export (float) var ice = 1
export (float) var wind = 1
export (float) var thunder = 1
export (float) var earth = 1
export (float) var psychic = 1
export (float) var ghost = 1
export (float) var light = 1
export (float) var dark = 1
export (float) var explosion = 1

var element_array = []

func _ready():
	element_array.append(normal)
	element_array.append(fire)
	element_array.append(water)
	element_array.append(ice)
	element_array.append(wind)
	element_array.append(thunder)
	element_array.append(earth)
	element_array.append(psychic)
	element_array.append(ghost)
	element_array.append(light)
	element_array.append(dark)
	element_array.append(explosion)

func set_resistance(element, value):
	var change_this = element_array[element]
	
	change_this = value

func check_resistance_effect(element):
	var check_this = element_array[element]
	
	if check_this == 1:
		return "normal"
	elif check_this > 1:
		return "amplify"
	elif check_this == 0:
		return "immune"
	elif check_this < 0:
		return "absorb"
	else:
		return "resist"