extends Button

onready var normal_position = get_position()
onready var selected_position = Vector2(normal_position.x - selected_offset, normal_position.y)

export (String) var press_action = ""
var active = false
const off_screen_position = 360
const selected_offset = 24

func _ready():
	$Tween.connect("tween_completed", self, "_on_Tween_Completed")
	set_position(Vector2(get_position().x + off_screen_position, get_position().y))
	visible = false
#	set_position(Vector2(get_position().x + off_screen_position, get_position().y))
#	enter_screen()

func enter_screen():
	visible = true
	$Tween.stop_all()
	set_position(Vector2(get_position().x + off_screen_position, get_position().y))
	$Tween.interpolate_method(self, "set_position", get_position(), normal_position, 1.3 , Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	active = true

func exit_screen():
	$Tween.stop_all()
	$Tween.interpolate_method(self, "set_position", get_position(), Vector2(get_position().x + off_screen_position, get_position().y), 0.9, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	active = false

func select():
	$Tween.stop_all()
	$Tween.interpolate_method(self, "set_position", get_position(), selected_position, 0.3, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()

func deselect():
	$Tween.stop_all()
	$Tween.interpolate_method(self, "set_position", get_position(), normal_position, 0.4, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()

func _on_Tween_Completed(object, key):
	pass

func _on_Button_mouse_entered():
	if active:
		select()

func _on_Button_mouse_exited():
	if active:
		deselect()

func _on_Button_button_down():
	if active:
		$AnimationPlayer.play("press")
