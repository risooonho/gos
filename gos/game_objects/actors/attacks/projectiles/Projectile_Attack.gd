extends "res://game_objects/primitive/Actor.gd"

const impact_delay = 0.02

export (float) var floating_height = 22
export (float) var lifetime = 1
export (PackedScene) var impact_attack 
onready var projectile_owner = $'../../Body'

var reflected = false
var life_timer = 0
var impact_timer = 0
var has_hit = false
var team = 0

func _ready():
#	attack_area.z_axis.set_z(self.z_axis.get_z() + hitbox_z_offset)
	hurtbox.get_node("Area_Shape").shape = self.get_node("Body_Shape").shape
	hurtbox.z_axis.set_height(self.z_axis.get_height())
	position = projectile_owner.position
	z_axis.set_z(projectile_owner.z_axis.get_z()+floating_height)
	react_on_wall_collision = true
	team = projectile_owner.stats.get_team()

func get_hit(attack):
	if (projectile_owner.stats.get_team() != attack.team && projectile_owner.stats.get_team() != projectile_owner.stats.team_list.NONE) || (projectile_owner.stats.get_team() == projectile_owner.stats.team_list.NEUTRAL):
		life_timer = 0
		reflected = true
		if team == 2:
			team = 1
		elif team == 1:
			team = 2
		reflect_projectile()

func spawn_attack():
	var attack = impact_attack.instance()
	attack.set_name("Attack")
	projectile_owner.get_parent().get_parent().add_child(attack)
	attack.position = self.position
	attack.init(self.z_axis.get_z(), move_direction, team, projectile_owner.stats.attack_power)
	get_parent().call_deferred("queue_free")

func _thrown_collision_reaction(collision):
	get_parent().queue_free()

func _vertical_thrown_collision_reaction():
	get_parent().queue_free()

func init(direction):
	move_direction = direction.normalized()

func reflect_projectile():
	velocity = -velocity
	move_direction = Vector3(-move_direction.x, -move_direction.y, -move_direction.z)

func _physics_process(delta):
	life_timer += delta
	if life_timer > lifetime:
		get_parent().queue_free()
	
	var colliding_areas = hurtbox.get_colliding_areas()
	
	for area in (colliding_areas):
		if area.get_name() == "Hurtbox":
			if (area.hurtbox_owner != self.projectile_owner) || reflected:
				spawn_attack()
