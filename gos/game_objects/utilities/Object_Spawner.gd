extends Position2D

var active = true

export (float) var time_to_spawn = 3
export (PackedScene) var object_to_spawn

onready var z_axis = get_node("Z_Axis")

var timer = 0
var spawned_object = null

func _process(delta):
	if active:
		if !get_parent().has_node("Object"):
			if timer < time_to_spawn:
				timer+=delta
			else:
				spawned_object = object_to_spawn.instance()
				spawned_object.set_name("Object")
				spawned_object.get_node("Body").position = self.position
				get_parent().add_child(spawned_object)
				spawned_object.get_node("Body").z_axis.set_z(z_axis.get_z())
				timer = 0
