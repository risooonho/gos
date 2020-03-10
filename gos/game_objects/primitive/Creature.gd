extends "res://game_objects/primitive/Actor.gd"

enum movement_states {IDLE, MOVING, SKID}
enum creature_sizes {NORMAL, HEAVY, LIGHT}

onready var stats = $'Stats'
onready var dmg_number_path = "res://game_objects/ui/ui_elements/Damage_Number.tscn"
onready var blood_path = "res://game_objects/particles/combat/Soulblood_Sys.tscn"
onready var knockback_smoke = get_particle_emitter().get_node("Knockback_Smoke")

export(String) var creature_name = ""
export (float) var stamina_recharge_rate = 0.5
export (float) var shield_stamina_cost = 0.3

var stamina_recharge_timer = 0
var shieldstun_time = 0
var knockback_time = 0 # When this is above 0, the creature is in hitstun and cannot control itself(player/AI). Counts down on its own.
var endlag_time = 0 # Like hitstun, the creature cannot control itself when this is above 0, but is the result of performing a move.
var invulnerability = false
var death_animation = false
var control_disabled = false
onready var look_direction = Vector2(0, 1)

#temp
var footstep_trail_timer = 0
var footstep_trail_freq = 0.2

func _ready():
	self.connect("actor_landed", self, "_on_actor_landed")
	$'AnimationPlayer'.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")

func is_in_shieldstun():
	if shieldstun_time > 0:
		return true
	return false

func is_shielding():
	return stats.shield_active

func activate_shield():
	if stats.stamina - shield_stamina_cost < 0:
		set_endlag(0.4)
		deactivate_shield()
	else:
		stats.shield_active = true

func deactivate_shield():
	stats.shield_active = false

func set_shieldstun(time):
	shieldstun_time = time

func _on_death():
	invulnerability = true
	globals.freeze_screen(0.1)
	$AnimationPlayer.play("death")

func _on_Stats_Hp_Changed(hp, max_hp, actor_id):
	if hp <= 0:
		_on_death()

func _on_actor_landed():
	create_jump_trail()

func create_footstep_trail():
	var footstep_trail = create_particle("res://game_objects/particles/actors/Footstep_Dirt_Trails.tscn", false, get_3d_position())
	footstep_trail.get_node("Z_Axis/Dirt").rotation = Vector2(-look_direction.x, -look_direction.y).angle()

func create_jump_trail():
	var jump_trail = create_particle("res://game_objects/particles/actors/Jump_Dirt_Trail_Group.tscn", false, get_3d_position())

func spawn_damage_number(damage, effect):
	var dmg_number = globals.instance_scene(get_parent(), dmg_number_path, "Damage_Number")
	dmg_number.init(damage, effect)
	dmg_number.position = Vector2(self.get_3d_position().x, self.get_3d_position().y - self.get_3d_position().z)

func deal_true_damage(amount):
	stats.take_or_heal_damage(amount)
	var effect = "normal"
	if amount < 0:
		effect = "absorb"
	spawn_damage_number(amount, effect)

func is_hittable():
	if stats.is_alive():
		if !invulnerability:
			if self.has_node("Grabbable"):
				if self.get_node("Grabbable").grabbed_state == self.get_node("Grabbable").grabbed_states.FREE:
					return true
			return true
	return false

func get_hit(attack):
	if is_hittable():
		if (self.stats.get_team() != attack.team && self.stats.get_team() != self.stats.team_list.NONE) || (self.stats.get_team() == self.stats.team_list.NEUTRAL):
			var damage_done = self.stats.calculate_and_damage(attack)
			var effect = stats.resistances.check_resistance_effect(attack.element)
			
			stats.combo_multiplier += 1
			
			#particle
			if !is_shielding():
				var blood = globals.instance_scene(get_particle_emitter(), blood_path, "Blood")
				#blood.set_3d_position(self.get_3d_position())
				blood.start_emitting()
				blood.particles[0].rotation =  Vector2(attack.knockback_direction.x, attack.knockback_direction.y).angle()
				blood.particles[0].process_material.initial_velocity = 350 + attack.knockback.x / 4
				
				knockback_smoke.start_emitting()
			
			var knockback_duration = attack.knockback_duration
#			if effect == "immune" || effect == "absorb" || heavy:
			var knockback = attack.knockback
			if is_shielding():
#				knockback.x *= stats.shield_multiplier
				knockback.y = 0
				stats.combo_multiplier = 0
				set_shieldstun(knockback_duration * stats.shield_multiplier)
				knockback_duration = 0
			if stats.resistances.element_array[attack.element] <= 0 || heavy:
				stats.combo_multiplier = 0
				knockback = Vector2(0, 0)
				knockback_duration = 0
				knockback_smoke.stop_emitting()
			self.apply_knockback(attack.knockback_direction.normalized(), knockback, knockback_duration)
			
			globals.get_game().get_camera().shake_camera(attack.camera_shake)
			spawn_damage_number(damage_done, effect)
			
			#change look direction to opposite of attack
			#play hitstun animation

func is_in_knockback():
	if knockback_time > 0:
		return true
	return false

func is_in_endlag():
	if endlag_time > 0:
		return true
	return false

func has_control():
	if !is_in_knockback() && !is_in_endlag() && !control_disabled && !is_in_shieldstun():
		return true
	return false

func apply_knockback(knockback_direction, knockback_force, knockback_duration):
	self.velocity = (Vector3(knockback_direction.x * knockback_force.x, knockback_direction.y * knockback_force.x, knockback_force.y))
	move_direction = Vector3(0, 0, 0)
	knockback_time = knockback_duration

func set_endlag(endlag):
	move_direction = Vector3(0, 0, 0)
	endlag_time = endlag

func knockback_end():
	z_axis.get_node("Sprite_Offset/Sprite").modulate = Color(1, 1, 1, 1)
	knockback_time = 0
	knockback_smoke.stop_emitting()
	react_on_wall_collision = false
	stats.combo_multiplier = 0

func _physics_process(delta):
	if is_in_knockback():
		if velocity.length() < 500:
			knockback_smoke.stop_emitting()
	
	if stats.is_alive():
		if is_in_knockback():
			knockback_time -= delta
			z_axis.get_node("Sprite_Offset/Sprite").modulate = Color(255, 0, 0, 255)
			react_on_wall_collision = true
			if !is_in_knockback():
				knockback_end()
		if is_in_endlag():
			endlag_time -= delta
		else:
			endlag_time = 0
		
		if is_in_shieldstun():
			shieldstun_time -= delta
		else:
			shieldstun_time = 0
		
		if is_shielding():
			print("shieldin")
			self.stats.deplete_or_replenish_stamina(-shield_stamina_cost)
			if stats.stamina - shield_stamina_cost < 0:
				deactivate_shield()
		
		stamina_recharge_timer += delta
		if stamina_recharge_timer > stamina_recharge_rate:
			self.stats.deplete_or_replenish_stamina(1)
			stamina_recharge_timer = 0
		
		if move_direction != Vector3(0, 0, 0):
			look_direction = move_direction
			if z_state == z_states.GROUNDED:
				footstep_trail_timer+= delta
				if footstep_trail_timer > footstep_trail_freq:
					create_footstep_trail()
					footstep_trail_timer = 0
			else:
				footstep_trail_timer = 0
		else:
			footstep_trail_timer = 0
