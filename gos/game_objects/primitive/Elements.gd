extends Node

enum elem_list {NORMAL, FIRE, WATER, ICE, WIND, THUNDER, EARTH, PSYCHIC, GHOST, LIGHT, DARK, EXPLOSION}

func get_element_name(element):
	match element:
		elem_list.NORMAL:
			return "normal"
		elem_list.FIRE:
			return "fire"
		elem_list.WATER:
			return "water"
		elem_list.ICE:
			return "ice"
		elem_list.WIND:
			return "wind"
		elem_list.THUNDER:
			return "thunder"
		elem_list.EARTH:
			return "earth"
		elem_list.PSYCHIC:
			return "psychic"
		elem_list.GHOST:
			return "ghost"
		elem_list.LIGHT:
			return "light"
		elem_list.DARK:
			return "dark"
		elem_list.EXPLOSION:
			return "explosion"

func get_element_color(element):
	match element:
		elem_list.NORMAL:
			return Color(255, 255, 255, 255)
		elem_list.FIRE:
			return Color(255, 0, 0, 255)