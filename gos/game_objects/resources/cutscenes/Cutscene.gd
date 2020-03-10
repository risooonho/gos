extends Node

onready var cutscene_manager = get_parent()
var actors = []
var sequence = []

func _ready():
	actors = []
	globals.get_ui().get_node("Dialogue_Box").connect("dialogue_ended", self, "_on_Dialogue_Ended")
	add_actor(globals.get_game().get_player())

func add_actor(actor):
	actors.append(actor)

func get_player():
	return actors[0]

func actor_look_at_player():
	pass

func _on_Dialogue_Ended():
	pass

func actor_look_at(direction):
	pass

func play_dialogue(dialogue_id):
	globals.get_ui().text_box.load_dialogue(dialogue_id)