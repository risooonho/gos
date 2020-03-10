extends "res://game_objects/ui/HUD_Element.gd"

onready var interactable = get_parent()
onready var text = $'Text'
func _ready():
	visible = false

func _on_Area_area_entered(area):
	if interactable.active:
		if area.get_name() == "Hurtbox":
			if area.hurtbox_owner.actor_id == "Player":
				_appear()

func _on_Area_area_exited(area):
	if interactable.active:
		if area.get_name() == "Hurtbox":
			if area.hurtbox_owner.actor_id == "Player":
				_disappear()
