extends Control

onready var anim_player = $'AnimationPlayer'

func _appear():
	visible = true
	anim_player.play("appear")

func _appear_end():
	pass

func _disappear():
	anim_player.play("disappear")

func _disappear_end():
	visible = false