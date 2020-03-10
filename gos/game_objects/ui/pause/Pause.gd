extends Control

func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()

func pause():
	visible = true
	get_tree().paused = true
	$AnimationPlayer.play("pause")

func unpause():
	$AnimationPlayer.play_backwards("pause")
	yield($AnimationPlayer, "animation_finished")
	get_tree().paused = false
	visible = false

func toggle_pause():
	if !get_tree().paused:
		pause()
	else:
		unpause()

func _on_Continue_pressed():
	unpause()


func _on_Return_pressed():
	globals.instance_scene(self, "res://game_objects/ui/confirmations/Return_To_Title_Confirmation.tscn", "Confirmation")
