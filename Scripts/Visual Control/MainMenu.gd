extends PanelContainer
class_name MainMenu

#class battle_p:
	#var mode= BATTLE_STATE.states.STATE_BATTLE_MULTIPLAYER.new()
	#var obce_type= BATTLE_STATE.states.STATE_BATTLE_MULTIPLAYER.STATE_DEPLOYING_OBSTACLE.STATE_PLAIN.new()
	#var input_type= INPUT_STATE.states.STATE_UI_BUTTON.new()
#var battle_prop= battle_p.new()
#
#func _on_battle_init():
	#$MarginContainer/clicka.play()
	#if battle_prop.obce_type == BATTLE_STATE.states.STATE_BATTLE_MULTIPLAYER.STATE_DEPLOYING_OBSTACLE.STATE_PREDEFINED and $MarginContainer/VBoxContainer/MainTab/BattleSetup.current_tab != 3:
		#$MarginContainer/VBoxContainer/MainTab/BattleSetup.current_tab = 3
	#else:
		#var rand = str(randi_range(0,1000))
		#var allplayertest = ['56789232','24214121']
		#battle = Battle.new(Global.mode,Global.conrol,Global.environment,rand,allplayertest)
		#battle.name = 'Battle'
		#get_parent().add_child(battle)
		#hide()
#
#func _process(delta):
	#if Global.is_battle_end == true :
		#get_parent().get_node("Battle").queue_free()
		#$MarginContainer/VBoxContainer/MainTab.current_tab = 0
		#Global.is_battle_end = false
		#show()
#
#func runTo_BattleSetup():
	#current_tab = 0

func _on_back_pressed():
	$MarginContainer/VBoxContainer/MainTab/BattleSetup.current_tab -= 1
	$MarginContainer/clickb.play()

func _on_go_pressed():
	#print(ControlCore.ordered_battle)
	if $MarginContainer/VBoxContainer/MainTab/BattleSetup.current_tab == 2 and $MarginContainer/VBoxContainer/MainTab/BattleSetup/MapSelect/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Predefined.button_pressed == true:
		$MarginContainer/VBoxContainer/MainTab/BattleSetup.current_tab = 3
		$MarginContainer/clicka.play()
	elif $MarginContainer/VBoxContainer/MainTab/BattleSetup.current_tab < 2:
			$MarginContainer/VBoxContainer/MainTab/BattleSetup.current_tab += 1
			$MarginContainer/clicka.play()
	else:
		$MarginContainer/clicka.play()
		Control_Core.game_control.roll_state()

#["MULTIPLAYER", "UI_BUTTON", "PREDEFINED", "ANDOR"]
func prepare() -> void:
	size= Control_Core.get_media_size()

func resize(media_size: Vector2):
	size= media_size

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


func _on_multiplayer_pressed():
	Control_Core.game_control.game_mode= GameControl.game_mode_enum.MULTIPLAYER
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/ModeSelect/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Multiplayer.button_pressed = true
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/ModeSelect/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Campaign.button_pressed = false
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/MapSelect/MarginContainer/VBoxContainer/OpTab.current_tab = 0
	$MarginContainer/switch.play()

func _on_campaign_pressed():
	Control_Core.game_control.game_mode= GameControl.game_mode_enum.CAMPAIGN
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/ModeSelect/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Multiplayer.button_pressed = false
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/ModeSelect/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Campaign.button_pressed = true
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/MapSelect/MarginContainer/VBoxContainer/OpTab.current_tab = 1
	$MarginContainer/switch.play()


func _on_battle_pressed():
	Control_Core.game_control.control_mode= GameControl.control_mode_enum.UIBUTTON
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/ControlSelect/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Battle.button_pressed = true
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/ModeSelect/MarginContainer/VBoxContainer/OpTab.current_tab = 0
	$MarginContainer/clicka.play()


func _on_plain_pressed():
	Control_Core.game_control.obstacle_mode= GameControl.obstacle_mode_enum.PLAIN
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/MapSelect/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Plain.button_pressed = true
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/MapSelect/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Predefined.button_pressed = false
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/MapSelect/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Random.button_pressed = false
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/MapSelect/MarginContainer/VBoxContainer/OpTab.current_tab = 0
	$MarginContainer/switch.play()

func _on_predefined_pressed():
	Control_Core.game_control.obstacle_mode= GameControl.obstacle_mode_enum.PREDEFINED
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/MapSelect/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Plain.button_pressed = false
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/MapSelect/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Predefined.button_pressed = true
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/MapSelect/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Random.button_pressed = false
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/MapSelect/MarginContainer/VBoxContainer/OpTab.current_tab = 1
	$MarginContainer/switch.play()

func _on_random_pressed():
	Control_Core.game_control.obstacle_mode= GameControl.obstacle_mode_enum.RANDOM
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/MapSelect/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Plain.button_pressed = false
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/MapSelect/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Predefined.button_pressed = false
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/MapSelect/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Random.button_pressed = true
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/MapSelect/MarginContainer/VBoxContainer/OpTab.current_tab = 2
	$MarginContainer/switch.play()


func _on_andor_pressed():
	Control_Core.game_control.predefined_map= GameControl.predefined_map_enum.ANDOR
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/PredefSelect/MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer/VBoxContainer/Andor.button_pressed = true
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/PredefSelect/MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer2/VBoxContainer2/Helios.button_pressed = false
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/PredefSelect/MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer3/VBoxContainer3/Andromeda.button_pressed = false
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/PredefSelect/MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer4/VBoxContainer4/Perseus.button_pressed = false
	$MarginContainer/switch.play()


func _on_helios_pressed():
	Control_Core.game_control.predefined_map= GameControl.predefined_map_enum.HELIOS
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/PredefSelect/MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer/VBoxContainer/Andor.button_pressed = false
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/PredefSelect/MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer2/VBoxContainer2/Helios.button_pressed = true
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/PredefSelect/MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer3/VBoxContainer3/Andromeda.button_pressed = false
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/PredefSelect/MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer4/VBoxContainer4/Perseus.button_pressed = false
	$MarginContainer/switch.play()

func _on_andromeda_pressed():
	Control_Core.game_control.predefined_map= GameControl.predefined_map_enum.ANDROMEDA
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/PredefSelect/MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer/VBoxContainer/Andor.button_pressed = false
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/PredefSelect/MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer2/VBoxContainer2/Helios.button_pressed = false
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/PredefSelect/MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer3/VBoxContainer3/Andromeda.button_pressed = true
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/PredefSelect/MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer4/VBoxContainer4/Perseus.button_pressed = false
	$MarginContainer/switch.play()

func _on_perseus_pressed():
	Control_Core.game_control.predefined_map= GameControl.predefined_map_enum.PERSEUS
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/PredefSelect/MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer/VBoxContainer/Andor.button_pressed = false
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/PredefSelect/MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer2/VBoxContainer2/Helios.button_pressed = false
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/PredefSelect/MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer3/VBoxContainer3/Andromeda.button_pressed = false
	$MarginContainer/VBoxContainer/MainTab/BattleSetup/PredefSelect/MarginContainer/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/PanelContainer4/VBoxContainer4/Perseus.button_pressed = true
	$MarginContainer/switch.play()

func _on_video_stream_player_finished():
	get_parent().get_node("Intro").visible = false
