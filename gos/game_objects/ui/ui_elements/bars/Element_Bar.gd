extends Control

func _ready():
	visible = false

func activate(time):
	visible = true
	$AnimationPlayer.play("appear")
	$Tween.interpolate_property($TextureProgress, "value", $TextureProgress.max_value, $TextureProgress.min_value, time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "disappear":
		visible = false

func disappear():
	$AnimationPlayer.play("disappear")

func _on_Tween_tween_completed(object, key):
	disappear()
