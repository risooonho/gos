extends "res://game_objects/primitive/Grabbable_Actor.gd"

signal exploded

func _ready():
	._ready()
	self.connect("exploded", globals.get_game(), "_on_Bomb_Exploded")

func get_hit(attack):
	_vertical_thrown_collision_reaction()
	emit_signal("exploded")

func _thrown_collision_reaction(collision):
	._thrown_collision_reaction(collision)
	emit_signal("exploded")
	get_parent().queue_free()

func _vertical_thrown_collision_reaction():
	._vertical_thrown_collision_reaction()
	emit_signal("exploded")
	get_parent().queue_free()