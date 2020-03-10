extends VBoxContainer

func _ready():
	visible = false
	for choice in self.get_children():
		choice.connect("pressed", self, "on_choice_pressed", [choice])
	yield(get_tree().create_timer(0.2), "timeout")
	visible = true
	choices_enter()

func choices_enter():
	for choice in self.get_children():
#		yield(get_tree().create_timer(0.07), "timeout")
		choice.enter_screen()

func choices_exit(exception):
	for choice in self.get_children():
		choice.active = false
		if choice != exception:
			choice.exit_screen()
	yield(get_tree().create_timer(0.6), "timeout")
	exception.exit_screen()

func on_choice_pressed(selection):
	#perform action of selection
	if selection.active:
		get_parent().perform_action(selection.press_action)
		choices_exit(selection)
