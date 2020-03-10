extends Node

onready var moveset_owner = get_parent()

const combo_window = 0.32
const projectile_stamina_cost = 10

var combo = 1
var combo_timer = 0

export (PackedScene) var projectile
export (PackedScene) var ground_standard_1
export (PackedScene) var ground_standard_2
export (PackedScene) var ground_standard_3
export (PackedScene) var ground_forward_1
export (PackedScene) var ground_forward_2
export (PackedScene) var ground_forward_3
export (PackedScene) var ground_setup
export (PackedScene) var ground_special
export (PackedScene) var aerial_standard
export (PackedScene) var aerial_forward
export (PackedScene) var aerial_setup
export (PackedScene) var aerial_special
export (PackedScene) var spin_attack

func attack_melee(attack_name):
	if attack_name == "ground_standard" || attack_name == "ground_forward":
		attack_name += "_" + str(combo)
		combo += 1
		if combo > 3:
			combo = 3
		combo_timer = 0
	var attack_instance = spawn_attack(attack_name)
	moveset_owner.add_child(attack_instance)
	attack_instance.init(moveset_owner.look_direction)

func attack_projectile(attack_name, parameter):
	if moveset_owner.get_parent().has_node("projectile"):
		return
	if moveset_owner.stats.stamina - projectile_stamina_cost < 0:
		return
	moveset_owner.stats.deplete_or_replenish_stamina(-projectile_stamina_cost)
	var attack_instance = spawn_attack(attack_name)
	moveset_owner.get_parent().add_child(attack_instance)
	attack_instance.get_node("Body").init(parameter)

func spawn_attack(attack_name):
	var queued_attack = get(attack_name)
	var attack_instance = queued_attack.instance()
	attack_instance.set_name(attack_name)
	return attack_instance

func _process(delta):
	if combo > 1:
		combo_timer += delta
		if combo_timer > combo_window:
			combo = 1
			combo_timer = 0