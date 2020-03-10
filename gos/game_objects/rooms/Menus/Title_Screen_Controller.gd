extends Control

var exit_flag = ""

onready var fade = $'Unscrollable/Fade_Out_In'

const changelog_path = "res://game_objects/ui/message_boards/presets/Changelog.tscn"
const credits_path = "res://game_objects/ui/message_boards/presets/Credits.tscn"
const about_path = "res://game_objects/ui/message_boards/presets/About.tscn"
const continue_path = "res://game_objects/ui/message_boards/presets/Continue.tscn"
const settings_path = "res://game_objects/ui/message_boards/presets/Settings.tscn"


func _ready():
	$Title_Animations.play("entrance")
	yield(get_tree().create_timer(0.25), "timeout")
	fade.fade_in()


func exit_title_screen(flag):
	if flag == "quit":
		globals.get_system().close_app()
	if flag == "new":
		globals.get_system().start_new_game()


func _on_Title_Animations_animation_finished(anim_name):
	if anim_name == "entrance":
		$Camera/Camera2D.active = true
	elif anim_name == "exit":
		exit_title_screen(exit_flag)


func open_message_board(path, node_name):
	yield(get_tree().create_timer(0.7), "timeout")
	var board = globals.instance_scene($Unscrollable, path, node_name)
	board.connect("board_closed", self, "on_board_closed")


func on_board_closed():
	$Title_Choices.choices_enter()


func perform_action(action_name):
	if action_name == "quit":
		exit_flag = action_name
		$Title_Animations.play("exit")
		yield(get_tree().create_timer(0.3), "timeout")
		fade.fade_out()
	elif action_name == "changelog":
		open_message_board(changelog_path, "Changelog")
	elif action_name == "credits":
		open_message_board(credits_path, "Credits")
	elif action_name == "continue":
		open_message_board(continue_path, "Continue")
	elif action_name == "new":
		exit_flag = action_name
		$Title_Animations.play("exit")
		yield(get_tree().create_timer(0.3), "timeout")
		fade.fade_out()
	elif action_name == "settings":
		open_message_board(settings_path, "Settings")
	elif action_name == "about":
		open_message_board(about_path, "About")

func _on_Title_Animations_animation_started(anim_name):
	if anim_name == "entrance":
		$Camera/Camera2D.active = false
	elif anim_name == "exit":
		$Camera/Camera2D.active = false
