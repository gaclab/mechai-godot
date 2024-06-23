extends PanelContainer


func _on_andor_pressed():
	$MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer/VBoxContainer/Andor.button_pressed = true
	$MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer2/VBoxContainer2/Helios.button_pressed = false
	$MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer3/VBoxContainer3/Andromeda.button_pressed = false
	$MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer4/VBoxContainer4/Perseus.button_pressed = false
	Global.selected_premap = 0
	get_parent().get_parent().get_node("BattleSetup/switch").play()


func _on_helios_pressed():
	$MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer/VBoxContainer/Andor.button_pressed = false
	$MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer2/VBoxContainer2/Helios.button_pressed = true
	$MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer3/VBoxContainer3/Andromeda.button_pressed = false
	$MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer4/VBoxContainer4/Perseus.button_pressed = false
	Global.selected_premap = 1
	get_parent().get_parent().get_node("BattleSetup/switch").play()

func _on_andromeda_pressed():
	$MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer/VBoxContainer/Andor.button_pressed = false
	$MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer2/VBoxContainer2/Helios.button_pressed = false
	$MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer3/VBoxContainer3/Andromeda.button_pressed = true
	$MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer4/VBoxContainer4/Perseus.button_pressed = false
	Global.selected_premap = 2
	get_parent().get_parent().get_node("BattleSetup/switch").play()

func _on_perseus_pressed():
	$MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer/VBoxContainer/Andor.button_pressed = false
	$MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer2/VBoxContainer2/Helios.button_pressed = false
	$MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer3/VBoxContainer3/Andromeda.button_pressed = false
	$MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer4/VBoxContainer4/Perseus.button_pressed = true
	Global.selected_premap = 3
	get_parent().get_parent().get_node("BattleSetup/switch").play()
