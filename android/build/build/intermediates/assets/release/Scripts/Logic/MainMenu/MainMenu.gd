extends PanelContainer
@onready var Battle = load("res://Scenes/Battle.tscn").instantiate()


func _on_play_pressed():
	$MarginContainer/VBoxContainer/Header/PanelContainer/HBoxContainer/PanelContainer/HBoxContainer/Play.button_pressed = true
	$MarginContainer/VBoxContainer/Header/PanelContainer/HBoxContainer/PanelContainer/HBoxContainer/Options.button_pressed = false
	$MarginContainer/VBoxContainer/MainTab.current_tab = 1
	$MarginContainer/clicka.play()


func _on_options_pressed():
	$MarginContainer/VBoxContainer/Header/PanelContainer/HBoxContainer/PanelContainer/HBoxContainer/Play.button_pressed = false
	$MarginContainer/VBoxContainer/Header/PanelContainer/HBoxContainer/PanelContainer/HBoxContainer/Options.button_pressed = true
	$MarginContainer/VBoxContainer/MainTab.current_tab = 2
	$MarginContainer/clicka.play()


func _on_quit_pressed():
	get_tree().quit()


func _on_margin_container_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("left-click"):
			$MarginContainer/VBoxContainer/Header/PanelContainer/HBoxContainer/PanelContainer/HBoxContainer/Play.button_pressed = false
			$MarginContainer/VBoxContainer/Header/PanelContainer/HBoxContainer/PanelContainer/HBoxContainer/Options.button_pressed = false
			$MarginContainer/VBoxContainer/MainTab.current_tab = 0


func _on_battle_init():
	$MarginContainer/clicka.play()
	if Global.maptype == 1 and $MarginContainer/VBoxContainer/MainTab/BattleSetup.current_tab != 3:
		$MarginContainer/VBoxContainer/MainTab/BattleSetup.current_tab = 3
	else:
		var startbattle = Battle.duplicate()
		get_parent().add_child(startbattle)
		hide()

func _process(delta):
	if Global.is_battle_end == true :
		print("end")
		print(get_parent().get_children())
		get_parent().get_node("Battle").queue_free()
		$MarginContainer/VBoxContainer/MainTab.current_tab = 0
		$MarginContainer/VBoxContainer/MainTab/BattleSetup.current_tab = 0
		Global.is_battle_end = false
		show()


func _on_video_stream_player_finished():
	get_parent().get_node("Intro").visible = false
