extends PanelContainer

func _on_battle_pressed():
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Battle.button_pressed = true
	$MarginContainer/VBoxContainer/OpTab.current_tab = 0
	get_parent().get_parent().get_node("BattleSetup/clicka").play()
