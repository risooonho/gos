extends Control

func update_value(value):
	animate_value($TextureProgress.value, value)

func animate_value(start, end):
	$Tween.interpolate_property($TextureProgress, "value", start, end, 0.14, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()