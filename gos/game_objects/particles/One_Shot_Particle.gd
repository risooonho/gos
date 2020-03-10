extends Particles2D

var timer = 0

export (float) var particle_time = 0

func _ready():
	self.emitting = true

func _process(delta):
	timer+=delta
	if one_shot:
		if timer > ((self.lifetime * self.speed_scale) * (1.9 - explosiveness)):
			get_parent().get_parent().call_deferred("queue_free")
	else:
		if timer > particle_time:
			get_parent().get_parent().call_deferred("queue_free")