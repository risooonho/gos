extends Node2D

export (String) var interact_label_string = "Interact"
export (bool) var active = true

onready var interact_label = $'Label'
onready var body = get_parent()
onready var interact_area = get_node("Area")

func _ready():
	interact_label.text.bbcode_text = "[center][color=#FFFF9C]F: [/color]" + interact_label_string +"[/center]"

func set_inactive():
	active = false
	interact_label._disappear()

func _input(event):
	if active:
		if event.is_action_pressed("interact"):
			var colliding_areas = interact_area.get_colliding_areas()
			
			for area in (colliding_areas):
				if area.get_name() == "Hurtbox":
					if area.hurtbox_owner.actor_id == "Player":
						if area.hurtbox_owner.has_control():
							body._interact(area.hurtbox_owner)
							interact_label._disappear()