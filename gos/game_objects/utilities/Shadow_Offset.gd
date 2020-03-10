extends Position2D

onready var body = get_parent()
var shadow_offset
func _ready():
	shadow_offset = position

func _physics_process(delta):
	position.y = shadow_offset.y - body.z_min
