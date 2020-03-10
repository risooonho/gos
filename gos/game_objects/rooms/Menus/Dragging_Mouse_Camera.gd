extends Camera2D

var screen_res 
var active

func _ready():
	update_screen_resolution()

func update_screen_resolution():
	screen_res = get_viewport_rect().size

func _physics_process(delta):
	if active:
		var mouse_pos = get_local_mouse_position()
		mouse_pos = Vector2(globals.clamp_value(mouse_pos.x, -(screen_res.x/2), screen_res.x/2), globals.clamp_value(mouse_pos.y, -(screen_res.y/2), screen_res.y/2))
	#	position = mouse_pos/6
	#	print(mouse_pos.y/screen_res.y)
		set_h_offset(mouse_pos.x/screen_res.x)
		set_v_offset(mouse_pos.y/screen_res.y)