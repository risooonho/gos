extends Control

var creature_id

func _ready():
	visible = false

func update_stamina_bar(stamina, max_stamina):
	$'Enemy_Stamina_Bar'.update_value(stamina)
	get_node("Enemy_Stamina_Bar/TextureProgress").max_value = max_stamina

func update_values(creature):
	if creature != creature_id:
		visible = true
		$Name.text = creature.creature_name
		$Combo.visible = (creature.stats.combo_multiplier > 1)
		$Combo.text = "Combo!" + str(creature.stats.combo_multiplier)
		$'Enemy_Health_Bar/TextureProgress'.max_value = creature.stats.max_health_points
		$'Enemy_Health_Bar/TextureProgress'.value = creature.stats.health_points
		$'Enemy_Stamina_Bar/TextureProgress'.max_value = creature.stats.max_stamina
		$'Enemy_Stamina_Bar/TextureProgress'.value = creature.stats.stamina
		creature_id = creature
	else:
		$Combo_Anim.stop()
		$Combo_Anim.play("combo")
		$Combo.visible = (creature.stats.combo_multiplier > 0)
		$Combo.text = str(creature.stats.combo_multiplier + 1)  + " Combo!"
		$'Enemy_Health_Bar'.update_value(creature.stats.health_points)
	$Enemy_Info_Timer.start(3)

func _on_Enemy_Info_Timer_timeout():
	creature_id = null
	visible = false
