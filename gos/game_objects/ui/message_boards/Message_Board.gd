extends Control


signal board_closed


func _ready():
	appear()


func appear():
	$AnimationPlayer.play("appear")


func disappear():
	$AnimationPlayer.play_backwards("appear")
	yield(self.get_node("AnimationPlayer"), "animation_finished")
	emit_signal("board_closed")
	self.queue_free()


func _on_Return_pressed():
	disappear()
