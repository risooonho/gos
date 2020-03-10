extends "res://game_objects/actors/attacks/projectiles/Projectile_Attack.gd"

func spawn_attack():
	var particles = particle_emitter.get_node("Fireball")
	particles.stop_emitting()
	particles.set_3d_position(get_3d_position())
	particles.queue_deletion(0.6)
	globals.reparent_node(particles, globals.get_world())
	.spawn_attack()
