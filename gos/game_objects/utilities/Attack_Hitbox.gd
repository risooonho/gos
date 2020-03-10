extends "res://game_objects/primitive/Area.gd"

enum knockback_styles {DIRECTION, RADIUS} 
enum CAMERA_SHAKE_STRENGTHS {NONE, WEAK, MEDIUM, MEDIUM_LONG, STRONG, HUGE}
export (knockback_styles) var knockback_style

export (CAMERA_SHAKE_STRENGTHS) var camera_shake = 0
export (float) var hitbox_duration = 0         # 0 = Infinite
export (float) var damage = 0				   # Base damage of the attack
export (Vector2) var knockback = Vector2(0, 0) # Horizontal knockback, vertical knockback
export (float) var knockback_duration = 0      # Hitstun duration
export (bool) var triggers_switches = false    # Property that says whether it can activate switches
export (bool) var reflector = false            # Property stating whether it reflects objects with the Reflectable property
export (preload("res://game_objects/primitive/Elements.gd").elem_list) var element = 0 # The attack's element
var timer = 0
var knockback_direction = Vector2(0,0)
var team = 0
var hit_objects = []

func init(z_position_in, knockback_direction_in, team_in, strength_in):
	z_axis.set_z(z_position_in + z_axis.get_z())
	knockback_direction = knockback_direction_in
	team = team_in
	damage *= 1 + (strength_in / 10)

func _process(delta):
	if hitbox_duration != 0:
		timer += delta
		
	if timer > hitbox_duration:
		self.queue_free()
	
	var colliding_areas = get_colliding_areas()
	for area in (colliding_areas):
		if area.get_name() == "Hurtbox":
			var hurtbox_owner = area.hurtbox_owner
			if hurtbox_owner.has_method("get_hit"):
				if not area in (hit_objects):
					if self.knockback_style == knockback_styles.RADIUS:
						knockback_direction = (area.global_position - self.global_position).normalized()
					hurtbox_owner.get_hit(self)
					hit_objects.append(area)
