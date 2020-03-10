extends Node

onready var attack_area = $'Disjoint_XY_Offset/Attack_Hitbox'
onready var attack_hitbox = $'Disjoint_XY_Offset/Attack_Hitbox/Area_Shape'
onready var attack_owner = get_parent()

export (float) var stamina_cost = 0
export(float) var startup_time = 0    # The time it takes for the hitbox to activate
export(float) var owner_endlag = 0  # The whole length of the move before the character can act again
export(Vector2) var owner_knockback = Vector2(0,0) # .x = Horizontal Self-knockback   .y = Vertical Self-knockback

var attack_direction = Vector2(0,0)   # Direction of the attack, given by the attack owner on initialization
var timer = 0						  # Used to count startup time, duration, etc

func _ready():
	attack_hitbox.disabled = true
	if attack_owner.stats.stamina - stamina_cost < 0:
		self.queue_free()
	else:
		attack_owner.stats.deplete_or_replenish_stamina(-stamina_cost)
		attack_owner.set_endlag(owner_endlag)

func init(direction_in):
	
	attack_direction = direction_in
	
	var attack_owner_stats = attack_owner.stats
	var team = attack_owner_stats.team
	var attack_strength = attack_owner_stats.attack_power
	
	if attack_area.knockback_style == attack_area.knockback_styles.DIRECTION:
		var horizontal_direction = Vector2(attack_direction.x, attack_direction.y)
		self.rotation = horizontal_direction.angle()
	
	attack_area.init(attack_owner.z_axis.get_z() - $'Disjoint_Z_Offset'.position.y, attack_direction, team, attack_strength)

func _process(delta):
	timer+=delta
	if self.has_node("Disjoint_XY_Offset/Attack_Hitbox"):
		if attack_hitbox.disabled == true:
			if timer > startup_time:
				attack_hitbox.disabled = false
				attack_owner.apply_impulse(Vector3(attack_direction.x * owner_knockback.x, attack_direction.y * owner_knockback.x, owner_knockback.y))
				timer = 0
		else:
			attack_area.z_axis.set_z(attack_owner.z_axis.get_z() - $'Disjoint_Z_Offset'.position.y)
	else:
		self.queue_free()