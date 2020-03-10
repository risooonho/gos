extends Control

# Every how many seconds will Vanylla blink in the portrait?
const blink_frequency = 2.6

# Every how many blinks will she do a fast double blink?
const fast_blink_frequency = 2

var timer = 0
var blink_counter = 0

func _process(delta):
	timer += delta
	if timer > blink_frequency:
		if blink_counter >= fast_blink_frequency:
			blink_counter = 0
			$'AnimationPlayer'.play("blink_fast")
		else:
			blink_counter += 1
			$'AnimationPlayer'.play("blink")
		
		timer = 0
