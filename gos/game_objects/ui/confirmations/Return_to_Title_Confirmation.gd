extends "res://game_objects/ui/confirmations/Confirmation_Box.gd"




func _on_Confirmation_Box_cancel_pressed():
	disappear()


func _on_Confirmation_Box_confirm_pressed():
	globals.get_system().return_to_title_screen()
	get_tree().paused = false
