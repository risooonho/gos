extends "res://game_objects/ui/HUD_Element.gd"

onready var speaker  = $'Speaker'
onready var text = $'Dialogue'
onready var input_arrow = $'Input_Arrow'

var active = false

signal dialogue_ended

var current_node_id
var current_node_speaker
var current_node_text
var current_node_next_id
var current_node_choices

var nodes = []

func _input(event):
	if active:
		if event is InputEventMouseButton:
			if event.button_index == 1 && event.pressed:
				if text.reached_end_of_page:
					change_node(current_node_next_id)
				else:
					text.fast_forward_message()

func load_dialogue(dialogue_id):
	var dialogue_path = "res://game_objects/resources/dialogues/dialogue_"+dialogue_id+".json"
	print(dialogue_path)
	var file = File.new()
	if file.file_exists(dialogue_path):
		file.open(dialogue_path, file.READ)
		var json_result = parse_json(file.get_as_text())
		current_node_id = 0
		nodes = json_result["Nodes"]
	else:
		print("Error loading Dialogue file.")
	file.close()
	
	if nodes:
		handle_current_node()
	else:
		print("Dialogue: Couldn't find nodes.")
	_appear()

func change_node(id):
	current_node_id = id
	handle_current_node()

func await_input():
	input_arrow.visible = true
	input_arrow.get_node("Arrow_Animation").play("arrow_animation")

func handle_current_node():
	text.empty_page()
	input_arrow.visible = false
	if current_node_id < 0:
		_disappear()
	else:
		if !grab_node(current_node_id):
			_disappear()
	update_text()

func grab_node(id):
	for node in nodes:
		if int(node["id"]) == id:
			current_node_speaker = "[center][color=#E3F9FF]" + node["name"] + "[/color][/center]"
			current_node_text = node["text"]
			current_node_next_id = int(node["next_id"])
			current_node_choices = node["choices"]
			return true
	return false

func update_text():
	text.bbcode_text = current_node_text
	speaker.bbcode_text = current_node_speaker

func _ready():
	visible = true
	input_arrow.visible = false

func _appear_end():
	active = true

func _disappear():
	active = false
	emit_signal("dialogue_ended")
	._disappear()