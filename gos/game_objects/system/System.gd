extends Node

const game_path = "res://game_objects/system/Game.tscn"
const title_path = "res://game_objects/rooms/Menus/Title.tscn"


func close_app():
	get_tree().quit()


func start_new_game():
	for child in self.get_children():
		child.queue_free()
	globals.instance_scene(self, game_path, "Game")


func save_game(file):
	pass


func load_game(file):
	pass


func return_to_title_screen():
	if self.has_node("Game"):
		globals.get_ui().fade.fade_out()
		yield(globals.get_ui().fade, "faded_out")
	for child in self.get_children():
		child.queue_free()
	
	globals.instance_scene(self, title_path, "Title")