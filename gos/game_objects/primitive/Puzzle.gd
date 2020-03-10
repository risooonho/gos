extends "res://game_objects/primitive/Node2D_Container.gd"

var results = []
var conditions = []

export (bool) var stay_activated = false

func _ready():
	._ready()
	for J in self.get_children():
		if J.has_node("Body/Result"):
			results.append(weakref(J.get_node("Body/Result")))
		elif J.has_node("Body/Condition"):
			conditions.append(weakref(J.get_node("Body/Condition")))

func _process(delta):
	var conditions_check = true
	for i in (conditions):
		if i.get_ref():
			if !i.get_ref().is_active():
				conditions_check =  false
	
	for i in (results):
		if i.get_ref():
			if i.get_ref().get_active_state() != conditions_check:
				i.get_ref().set_active_state(conditions_check)
	
	if stay_activated:
		if conditions_check == true:
			for i in (conditions):
				if i.get_ref():
					if i.get_ref().get_parent().get("working"):
						i.get_ref().get_parent().working = false