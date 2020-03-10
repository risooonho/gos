extends Control

signal faded_in
signal faded_out

func fade_out():
	visible = true
	$AnimationPlayer.play("fade")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("faded_out")


func fade_in():
	$AnimationPlayer.play_backwards("fade")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("faded_in")
	visible = false
