extends Node

enum team_list {NEUTRAL, ALLY, ENEMY, NONE}

const max_combo = 6

export (float) var max_health_points = 10
export (float) var attack_power = 1
export (team_list) var team = 0
export (float) var max_stamina = 50
export (float) var shield_multiplier = 0.4
export (preload("res://game_objects/primitive/Elements.gd").elem_list) var element = 0

onready var health_points = max_health_points
onready var stamina = max_stamina
onready var resistances = $'Resistances'

var combo_multiplier = 0
var shield_active = false

signal hp_changed
signal stamina_changed

func _ready():
	self.connect("hp_changed", get_parent(), "_on_Stats_Hp_Changed")
	self.connect("hp_changed", globals.get_ui(), "_on_Stats_Hp_Changed")
	self.connect("stamina_changed", globals.get_ui(), "_on_Stats_Stamina_Changed")

func is_alive():
	if health_points>0:
		return true
	else:
		return false

func get_team():
	return team

func deplete_or_replenish_stamina(value):
	stamina += value
	if stamina < 0:
		stamina = 0
	if stamina > max_stamina:
		stamina = max_stamina
	emit_signal("stamina_changed", stamina, max_stamina, get_parent())

func take_or_heal_damage(damage):
	if is_alive():
		health_points -= damage
		if health_points < 0:
			health_points = 0
		if health_points > max_health_points:
			health_points = max_health_points
		emit_signal("hp_changed", health_points, max_health_points, get_parent())

func calculate_and_damage(attack):
	var damage = 0
	var combo_multiplier_final = float(combo_multiplier)
	
	if combo_multiplier_final > max_combo:
		combo_multiplier_final = 0
	
	damage = attack.damage
	combo_multiplier_final = 1 + ((combo_multiplier_final / 10) * 2)
	if shield_active:
		damage *= shield_multiplier
		combo_multiplier_final = 1
	damage *= resistances.element_array[attack.element]
	damage *= combo_multiplier_final
	damage = round(damage)
	take_or_heal_damage(damage)
	
	return damage
