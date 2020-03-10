extends Control

signal confirm_pressed
signal cancel_pressed

func _ready():
	appear()

func appear():
	$AnimationPlayer.play("appear")

func disappear():
	$AnimationPlayer.play_backwards("appear")
	yield(self.get_node("AnimationPlayer"), "animation_finished")
	self.queue_free()

func _on_Yes_pressed():
	emit_signal("confirm_pressed")
	disappear()


func _on_No_pressed():
	emit_signal("cancel_pressed")
	disappear()
