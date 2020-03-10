extends Control

enum MAX_VALUE_STYLES {NONE, SHOW, COLOR}

export (bool) var center_text = false
export (String) var normal_text_color = "#FFFFFF"
export (MAX_VALUE_STYLES) var max_value_indicator = 0

var current_value = 0
var max_value = 0 # Used for changing the color of the value to indicate that the max of whatever it is has been reached

func update_value(value, max_value_in):
	max_value = max_value_in
	animate_value(current_value, value)

func animate_value(start, end):
#	$Tween.interpolate_property(self, current_value, start, end, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.interpolate_method(self, "update_text", start, end, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()

func update_text(value):
	current_value = value
	var text_color
	if  max_value_indicator == MAX_VALUE_STYLES.COLOR && current_value == max_value:
		text_color = "#4596FF"
	else:
		text_color = normal_text_color
	
	var text = ""
	if center_text:
		text += "[center]"
	text += "[color=" + text_color + "]" + str(round(current_value))
	if max_value_indicator == MAX_VALUE_STYLES.SHOW:
		text+= "/" + str(round(max_value))
	text += "[/color]"
	if center_text:
		text += "[/center]"
	
	$'Text'.bbcode_text = text