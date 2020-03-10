extends CanvasLayer

var toggle = true

onready var fade = $'Fade_Out_In'
onready var text_box = $'Dialogue_Box'
onready var game_hud = $'Gameplay_HUD'
onready var area_name = $'Area_Name'

var previous_level_name = null

func _ready():
	$'Dialogue_Box'.visible = false
	$'Cutscene_Borders'.visible = false

func cutscene_start_animations():
	$'Cutscene_Borders'._appear()
	game_hud._disappear()

func cutscene_end_animations():
	$'Cutscene_Borders'._disappear()
	game_hud._appear()

func play_cutscene():
	$'Dialogue_Box'._appear()
	$'Cutscene_Borders'._appear()

func end_cutscene():
	$'Dialogue_Box'._disappear()
	$'Cutscene_Borders'._disappear()

func _on_Stats_Stamina_Changed(stamina, max_stamina, creature):
	if creature.actor_id == "Player":
		var stamina_bar = game_hud.get_node("Stamina_Bar")
		stamina_bar.update_value(stamina)
		stamina_bar.get_node("TextureProgress").max_value = max_stamina
#	if creature == temp_enemy_info:
#		game_hud.get_node("Enemy_Info").update_stamina_bar(stamina, max_stamina)

func _on_Player_Element_Changed(element, time):
	game_hud.get_node("Element_Bar").activate(time)
	game_hud.get_node("Element_Symbol/Element_Sprite").frame = element

func _on_Player_Element_Discarded():
	game_hud.get_node("Element_Bar").disappear()
	game_hud.get_node("Element_Symbol/Element_Sprite").frame = 0

func _on_Player_Essence_Changed(current_essence, max_essence):
	game_hud.get_node("Essence_Counter").update_value(current_essence, max_essence)

func _on_Player_Keys_Changed(current_keys):
	game_hud.get_node("Key_Counter").update_value(current_keys, 9999)

func _on_Stats_Hp_Changed(hp, max_hp, creature):
	if creature.actor_id == "Player":
		game_hud.get_node("Heart_Bar").update_values(hp, max_hp)
	else:
		game_hud.get_node("Enemy_Info").update_values(creature)

func check_level_name_change(new_level_name):
	if previous_level_name != new_level_name:
		area_name.get_node("Text").bbcode_text = "[center][u]" + new_level_name + "[/u][/center]"
		area_name._appear()
		previous_level_name = new_level_name