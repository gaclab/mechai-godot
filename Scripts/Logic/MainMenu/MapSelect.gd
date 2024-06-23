extends PanelContainer

func _on_plain_pressed():
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Plain.button_pressed = true
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Predefined.button_pressed = false
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Random.button_pressed = false
	$MarginContainer/VBoxContainer/OpTab.current_tab = 0
	Global.maptype = 0

func _on_predefined_pressed():
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Plain.button_pressed = false
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Predefined.button_pressed = true
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Random.button_pressed = false
	$MarginContainer/VBoxContainer/OpTab.current_tab = 1
	Global.maptype = 1

func _on_random_pressed():
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Plain.button_pressed = false
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Predefined.button_pressed = false
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Random.button_pressed = true
	$MarginContainer/VBoxContainer/OpTab.current_tab = 2
	Global.maptype = 2
