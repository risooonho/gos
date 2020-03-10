extends Node2D

onready var particles = get_node("Z_Axis").get_children()
onready var is_bodyless = true
onready var z_axis = $Z_Axis

func _ready():
	particles = get_node("Z_Axis").get_children()
	for particle in particles:
		if particle is Position2D:
			particles.erase(particle)

func start_emitting():
	for particle in particles:
		particle.emitting = true

func stop_emitting():
	for particle in particles:
		particle.emitting = false

func queue_deletion(sec):
	var timer = Timer.new()
	add_child(timer)
	timer.start(sec)
	yield(timer, "timeout")
	print("particle freed:")
	self.queue_free()

func set_color_all(color_in):
	for particle in particles:
		particle.color = color_in


func set_color(idx, color_in):
	particles[idx].color = color_in


func set_3d_position(pos):
	position = Vector2(pos.x, pos.y)
	$Z_Axis.set_z(pos.z)
