extends "res://game_objects/primitive/Area.gd"

onready var hurtbox_owner = get_parent()

var hitbox_z_offset = 0

func _ready():
	hitbox_z_offset = z_axis.get_z()

func update_z():
	z_axis.set_z(hurtbox_owner.z_axis.get_z() + hitbox_z_offset)

