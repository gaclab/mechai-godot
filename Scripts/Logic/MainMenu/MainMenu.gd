extends PanelContainer

signal nextState()

func _on_play_pressed():
	$MarginContainer/VBoxContainer/Header/PanelContainer/HBoxContainer/PanelContainer/HBoxContainer/Play.button_pressed = true
	$MarginContainer/VBoxContainer/Header/PanelContainer/HBoxContainer/PanelContainer/HBoxContainer/Options.button_pressed = false
	$MarginContainer/VBoxContainer/MainTab.current_tab = 1


func _on_options_pressed():
	$MarginContainer/VBoxContainer/Header/PanelContainer/HBoxContainer/PanelContainer/HBoxContainer/Play.button_pressed = false
	$MarginContainer/VBoxContainer/Header/PanelContainer/HBoxContainer/PanelContainer/HBoxContainer/Options.button_pressed = true
	$MarginContainer/VBoxContainer/MainTab.current_tab = 2


func _on_quit_pressed():
	get_tree().quit()


func _on_margin_container_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left-click"):
			$MarginContainer/VBoxContainer/Header/PanelContainer/HBoxContainer/PanelContainer/HBoxContainer/Play.button_pressed = false
			$MarginContainer/VBoxContainer/Header/PanelContainer/HBoxContainer/PanelContainer/HBoxContainer/Options.button_pressed = false
			$MarginContainer/VBoxContainer/MainTab.current_tab = 0


func _on_battle_init():
	if Global.maptype == 1 and $MarginContainer/VBoxContainer/MainTab/BattleSetup.current_tab != 3:
		$MarginContainer/VBoxContainer/MainTab/BattleSetup.current_tab = 3
	else:
		nextState.emit()
		hide()
