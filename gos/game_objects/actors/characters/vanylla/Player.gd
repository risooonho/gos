extends "res://game_objects/primitive/Creature.gd"

const spin_attack_input_window = 0.05
const transformation_endlag = 0.5
const transformation_time = 17
const push_force = 130

const parry_time_threshold = 0.2
const parry_time = 0.13
const parry_fail_endlag = 1.1
var parry_attack = load("res://game_objects/actors/attacks/movesets/Parry.tscn")

onready var jump_force = 900
onready var moveset = $'Moveset'
onready var grab = $'Grabber'

signal essence_changed
signal element_changed
signal keys_changed
signal element_discarded

var spin_attack_input = 0
var spin_reset_counter = 0
var saved_pointer_angle = 0
var shield_held_time = 0

var elemental_form_timer = 0
var essence = 0
var max_essence = 200
var small_keys = 0
var is_parrying = false

func _ready():
	stats.take_or_heal_damage(0)
	connect_signals()


func _on_death():
	invulnerability = true
	globals.get_game().game_over()
	self.queue_free()


func collect_or_spend_essence(value):
	essence += value
	essence = globals.clamp_value(essence, 0, max_essence)
	emit_signal("essence_changed", essence, max_essence)

func collect_key():
	small_keys += 1
	emit_signal("keys_changed", small_keys)

func use_key():
	small_keys -=1
	emit_signal("keys_changed", small_keys)

func connect_signals():
	self.connect("essence_changed", globals.get_ui(), "_on_Player_Essence_Changed")
	self.connect("element_changed", globals.get_ui(), "_on_Player_Element_Changed")
	self.connect("keys_changed", globals.get_ui(), "_on_Player_Keys_Changed")
	self.connect("element_discarded", globals.get_ui(), "_on_Player_Element_Discarded")

func spin_attack_input():
	if spin_attack_input > 360 || spin_attack_input < -360:
		return true
	else:
		return false

func discard_element():
	emit_signal("element_discarded")
	elemental_shift(elements.elem_list.NORMAL)
	particle_emitter.get_node("Element_Sparkles").stop_emitting()
	particle_emitter.get_node("Element_Sparkles").set_color_all(elements.get_element_color(stats.element))
	create_particle("res://game_objects/particles/actors/Player/Player_Discard_Element_Group.tscn", true, Vector3(0, 0, 0))
	elemental_form_timer = 0

func elemental_shift(element):
	if !element == elements.elem_list.NORMAL:
		particle_emitter.get_node("Element_Sparkles").start_emitting()
		particle_emitter.get_node("Element_Sparkles").set_color_all(elements.get_element_color(stats.element))
		elemental_form_timer = transformation_time
		var absorb_particle = create_particle("res://game_objects/particles/combat/Soul_Absorbed.tscn", true, Vector3(0, 0 , -grab.get_node("XY_Offset/Z_Offset").position.y))
		absorb_particle.set_color_all(elements.get_element_color(stats.element))
		emit_signal("element_changed", element, elemental_form_timer)
	
	stats.element = element
	

	self.remove_child(moveset)
	moveset.call_deferred("free")
	
	var new_moveset_path = "res://game_objects/actors/attacks/movesets/"
	new_moveset_path += elements.get_element_name(element) + "_moveset.tscn"
	
	var new_moveset = load(new_moveset_path).instance()
	self.add_child(new_moveset)
	
	moveset = new_moveset
	
	print ("sailor " + elements.get_element_name(element) + "!!!!!!!")

func _actor_specific_wall_reaction(collision):
	if has_control():
		if z_state == z_states.GROUNDED:
			if collision.collider.get("actor_id"):
				if collision.collider.actor_id == "Pushable":
					var push_direction = move_direction.normalized()
					collision.collider.add_force(Vector3(-collision.normal.x*push_force, -collision.normal.y*push_force, 0))

func check_grabbed_object(object):
	grab.grab_object(object)
	
	if object.actor_id == "collectible":
		grab.release_grabbed_object()

func _input(event):
	if has_control():
		if event is InputEventMouseButton:
			if event.button_index == 1 && event.pressed:
				if !is_shielding():
					if !grab.is_holding_object():
						moveset.attack_projectile("projectile", Vector3(get_pointer_position().x, get_pointer_position().y, self.z_axis.get_z()))
					else:
						grab.throw_grabbed_object(get_pointer_direction())
			if event.button_index == 2 && event.pressed:
				deactivate_shield()
				if z_state == z_states.GROUNDED:
					if spin_attack_input():
						moveset.attack_melee("spin_attack")
					else:
						if move_direction.x == 0 and move_direction.y == 0:
							moveset.attack_melee("ground_standard")
						else:
							moveset.attack_melee("ground_forward")
				else:
					if move_direction.x == 0 and move_direction.y == 0:
						moveset.attack_melee("aerial_standard")
					else:
						moveset.attack_melee("aerial_forward")

func get_pointer_position():
	return Vector2(get_local_mouse_position().x,get_local_mouse_position().y + z_axis.get_z())

func get_3d_pointer_position():
	return Vector3(get_local_mouse_position().x,get_local_mouse_position().y - z_axis.get_z(), z_axis.get_z())

func get_pointer_direction():
	return Vector3(get_pointer_position().x, get_pointer_position().y, 0).normalized()

func spin_attack_process(delta):
		spin_reset_counter += delta
		if spin_reset_counter > spin_attack_input_window:
			spin_attack_input = 0
			spin_reset_counter = 0
		
		var angle_delta2 = rad2deg(Vector2(get_pointer_direction().x, get_pointer_direction().y).angle()) - saved_pointer_angle
		if !angle_delta2 > 300 and !angle_delta2 < -300:
			spin_attack_input += angle_delta2
			if angle_delta2 > 1 or angle_delta2 < -1:
				spin_reset_counter = 0
		
		saved_pointer_angle = rad2deg(Vector2(get_pointer_direction().x, get_pointer_direction().y).angle())

func get_hit(attack):
	if is_parrying:
		globals.freeze_screen(0.3)
		set_endlag(0)
		attack.hit_objects.append(hurtbox)
		var parry = globals.instance_scene(self, parry_attack, "Parry_Attack")
		parry.init(z_axis.get_z(), Vector2(0, 0), stats.team, stats.attack_power)
		yield(get_tree().create_timer(0.15), "timeout")
		is_parrying = false
	else:
		.get_hit(attack)

func parry():
	set_endlag(parry_fail_endlag)
	is_parrying = true
	print("parry")
	yield(get_tree().create_timer(parry_time), "timeout")
	is_parrying = false

func handle_inputs(delta):
	move_direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	move_direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	
	var attack_to_spawn = ""
	if z_state == z_states.GROUNDED:
		attack_to_spawn += "ground"
	else:
		attack_to_spawn += "aerial"
	
	if int(Input.is_action_pressed("shift")):
		shield_held_time += delta
		if shield_held_time >= parry_time_threshold:
			if z_state == z_states.GROUNDED:
				move_direction = Vector3(0, 0, 0)
				activate_shield()
	else:
		deactivate_shield()
	
	if int(Input.is_action_just_pressed("discard")):
		deactivate_shield()
		if grab.is_holding_object():
			grab.held_object.apply_impulse(Vector3(look_direction.x*300, look_direction.y*300, 320))
			if grab.held_object.actor_id == "Soul":
				if grab.held_object.stats.element != self.stats.element && (grab.held_object.stats.element != elements.elem_list.EXPLOSION):
					elemental_shift(grab.held_object.stats.element)
					self.set_endlag(transformation_endlag)
				else:
					grab.held_object.hit_something()
				grab.held_object.dying = true
			grab.release_grabbed_object()
		else:
			discard_element()
	
	if int(Input.is_action_just_released("shift")):
		deactivate_shield()
		if shield_held_time < parry_time_threshold:
			if z_state == z_states.GROUNDED:
				parry()
		shield_held_time = 0
	
	if int(Input.is_action_just_pressed("space")):
		deactivate_shield()
		if z_state == z_states.GROUNDED:
			apply_impulse(Vector3(0, 0, jump_force))
			create_jump_trail()
		elif z_state == z_states.AIRBORNE:
			if grab.is_holding_object() && z_axis.get_z() - z_min > 60 :
				velocity.z = jump_force * 1.3
				grab.held_object.z_axis.set_z(z_axis.get_z()-grab.held_object.z_axis.get_height())
				grab.throw_grabbed_object(Vector3(0, 0, -0.5))
	
	if int(Input.is_action_just_released("space")):
		if get_z_velocity() > 0:
			velocity.z = velocity.z * 0.58
	
	if int(Input.is_action_just_pressed("action_1")):
		deactivate_shield()
		attack_to_spawn += "_setup"
		moveset.attack_melee(attack_to_spawn)
	
	if int(Input.is_action_just_pressed("action_2")):
		deactivate_shield()
		attack_to_spawn += "_special"
		moveset.attack_melee(attack_to_spawn)
	

func _physics_process(delta):
	spin_attack_process(delta)
	
	if elemental_form_timer > 0:
		elemental_form_timer -= delta
		if elemental_form_timer <= 0:
			discard_element()
	
	if has_control():
		handle_inputs(delta)
	
