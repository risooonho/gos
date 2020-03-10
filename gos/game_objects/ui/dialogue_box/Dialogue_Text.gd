extends RichTextLabel

onready var text_box = get_parent()
const text_speed_frequency = 0.04

var text_timer = 0
var reached_end_of_page = false

func fast_forward_message():
	visible_characters = get_total_character_count()
	
func empty_page():
	reached_end_of_page = false
	text_timer = 0
	visible_characters = 0

func _process(delta):
	if text_box.active:
		if visible_characters != get_total_character_count():
			text_timer += delta
			if text_timer >= text_speed_frequency:
				visible_characters += 1
				text_timer -= text_speed_frequency
		else:
			if !reached_end_of_page:
				reached_end_of_page = true
				text_box.await_input()
