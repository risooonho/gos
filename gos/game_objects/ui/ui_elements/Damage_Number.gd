extends Node2D

const white = "#FAFAFA"
const pink = "#FCA6FF"
const purple = "#6754B3"
const orange = "#FAC07D"
const green = "#81FA5D"

func init(number, effect):
	var dmg_text = "[center][color="
	match effect:
		"normal":
			dmg_text += white
		"amplify":
			dmg_text += orange
		"immune":
			dmg_text += purple
		"absorb":
			dmg_text += green
		"resist":
			dmg_text += pink
	
	dmg_text += "]" + String(abs(number)) + "[/color][/center]"
	
	$'Text'.bbcode_text = dmg_text
	$'AnimationPlayer'.play("damage_number")

func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()
