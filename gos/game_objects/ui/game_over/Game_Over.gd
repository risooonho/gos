extends Control

func _ready():
	$AnimationPlayer.play("game_over")


func _on_AnimationPlayer_animation_finished(anim_name):
	yield(get_tree().create_timer(0.5), "timeout")
	$Choices.visible = true


func _on_Retry_pressed():
	print("Loading last quick save...")


func _on_Load_File_pressed():
	print("Open load file menu, same as continue from title screen")


func _on_Return_pressed():
	globals.instance_scene(self, "res://game_objects/ui/confirmations/Return_To_Title_Confirmation.tscn", "Confirmation")
