extends Node

var timer = 0
var freeze_time = 0

func freeze_screen(sec):
	get_tree().paused = true
	freeze_time = sec


func _on_freeze_timer_timeout():
	get_tree().paused = false

func _process(delta):
	if freeze_time > 0:
		timer += delta
		if timer > freeze_time:
			get_tree().paused = false
			timer = 0
			freeze_time = 0