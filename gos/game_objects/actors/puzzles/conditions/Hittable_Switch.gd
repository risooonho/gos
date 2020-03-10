extends "res://game_objects/actors/puzzles/conditions/Switch.gd"

# Works logically with One Time Press, Timed and Trigger

func get_hit(attack):
	if !is_held:
		if attack.triggers_switches:
			self.activate()

func _process(delta):
	if is_held:
		cooldown_timer += delta
		if cooldown_timer >= press_cooldown:
			self.deactivate()
			cooldown_timer = 0