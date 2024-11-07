extends PanelContainer



func _on_multiplayer_pressed():
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Multiplayer.button_pressed = true
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Campaign.button_pressed = false
	$MarginContainer/VBoxContainer/OpTab.current_tab = 0
	get_parent().get_parent().get_node("BattleSetup/switch").play()

func _on_campaign_pressed():
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Multiplayer.button_pressed = false
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Campaign.button_pressed = true
	$MarginContainer/VBoxContainer/OpTab.current_tab = 1
	get_parent().get_parent().get_node("BattleSetup/switch").play()
