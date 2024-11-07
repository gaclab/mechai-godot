extends PanelContainer

func _on_plain_pressed():
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Plain.button_pressed = true
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Predefined.button_pressed = false
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Random.button_pressed = false
	$MarginContainer/VBoxContainer/OpTab.current_tab = 0
	Global.obstacle_type = 0
	get_parent().get_parent().get_node("BattleSetup/switch").play()

func _on_predefined_pressed():
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Plain.button_pressed = false
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Predefined.button_pressed = true
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Random.button_pressed = false
	$MarginContainer/VBoxContainer/OpTab.current_tab = 1
	Global.obstacle_type = 1
	get_parent().get_parent().get_node("BattleSetup/switch").play()

func _on_random_pressed():
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Plain.button_pressed = false
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Predefined.button_pressed = false
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Random.button_pressed = true
	$MarginContainer/VBoxContainer/OpTab.current_tab = 2
	Global.obstacle_type = 2
	get_parent().get_parent().get_node("BattleSetup/switch").play()
