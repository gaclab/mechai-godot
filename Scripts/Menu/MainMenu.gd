extends PanelContainer
@onready var battle : Battle

var bcs0 = "Probability"
func _ready() -> void:
	#print(Global.debugsteer)
	
	Global.debugsteer[bcs0] = {}
	Global.debugsteer[bcs0] = {
		"Title click"= {},
		"Play click"= {},
		"Options click"= {},
		"Quit click"= {},
		"Process exec"= {}
	}

func _on_play_pressed():
	Global.debugsteer[bcs0]["Play click"]["Play pressed true"] = {}
	$MarginContainer/VBoxContainer/Header/PanelContainer/HBoxContainer/PanelContainer/HBoxContainer/Play.button_pressed = true
	
	Global.debugsteer[bcs0]["Play click"]["Options pressed false"] = {}
	$MarginContainer/VBoxContainer/Header/PanelContainer/HBoxContainer/PanelContainer/HBoxContainer/Options.button_pressed = false
	
	Global.debugsteer[bcs0]["Play click"]["Current tab 0 / Home"] = {}
	$MarginContainer/VBoxContainer/MainTab.current_tab = 1
	
	Global.debugsteer[bcs0]["Play click"]["Clicka sound play"] = {}
	$MarginContainer/clicka.play()


func _on_options_pressed():
	Global.debugsteer[bcs0]["Options click"]["Play pressed false"] = {}
	$MarginContainer/VBoxContainer/Header/PanelContainer/HBoxContainer/PanelContainer/HBoxContainer/Play.button_pressed = false
	
	Global.debugsteer[bcs0]["Options click"]["Options pressed true"] = {}
	$MarginContainer/VBoxContainer/Header/PanelContainer/HBoxContainer/PanelContainer/HBoxContainer/Options.button_pressed = true
	
	Global.debugsteer[bcs0]["Options click"]["Current tab 2 / Options"] = {}
	$MarginContainer/VBoxContainer/MainTab.current_tab = 2
	
	Global.debugsteer[bcs0]["Options click"]["Clicka sound play"] = {}
	$MarginContainer/clicka.play()


func _on_quit_pressed():
	Global.debugsteer[bcs0]["Quit click"]["Quit game"] = {}
	get_tree().quit()


func _on_margin_container_gui_input(event):
	var bcs1 = "InputEventMouseButton check"
	if event is InputEventMouseButton:
		Global.debugsteer[bcs0]["Title click"][bcs1] = {}
		
		var bcs2 = "left-click check"
		if event.is_action_pressed("left-click"):
			Global.debugsteer[bcs0]["Title click"][bcs1][bcs2] = {}
			
			Global.debugsteer[bcs0]["Title click"][bcs1][bcs2]["Play pressed false"] = {}
			$MarginContainer/VBoxContainer/Header/PanelContainer/HBoxContainer/PanelContainer/HBoxContainer/Play.button_pressed = false
			
			Global.debugsteer[bcs0]["Title click"][bcs1][bcs2]["Options pressed false"] = {}
			$MarginContainer/VBoxContainer/Header/PanelContainer/HBoxContainer/PanelContainer/HBoxContainer/Options.button_pressed = false
			
			Global.debugsteer[bcs0]["Title click"][bcs1][bcs2]["Current tab 0 / Home"] = {}
			$MarginContainer/VBoxContainer/MainTab.current_tab = 0

func _on_battle_init():
	$MarginContainer/clicka.play()
	if Global.obstacle_type == 1 and $MarginContainer/VBoxContainer/MainTab/BattleSetup.current_tab != 3:
		$MarginContainer/VBoxContainer/MainTab/BattleSetup.current_tab = 3
	else:
		var rand = str(randi_range(0,1000))
		var allplayertest = ['56789232','24214121']
		battle = Battle.new(Global.mode,Global.conrol,Global.environment,rand,allplayertest)
		battle.name = 'Battle'
		get_parent().add_child(battle)
		hide()

func _process(delta):
	var bcs1 = "Global.is_battle_end check"
	if Global.is_battle_end == true :
		Global.debugsteer[bcs0]["Process exec"][bcs1] = {}
		
		Global.debugsteer[bcs0]["Process exec"][bcs1]["Battle node queue_free"] = {}
		get_parent().get_node("Battle").queue_free()
		
		Global.debugsteer[bcs0]["Process exec"][bcs1]["Current tab 0 / Home"] = {}
		$MarginContainer/VBoxContainer/MainTab.current_tab = 0
		
		Global.debugsteer[bcs0]["Process exec"][bcs1]["Current tab 1 / Battle setup"] = $MarginContainer/VBoxContainer/MainTab/BattleSetup.runTo_BattleSetup()
		print(Global.debugsteer)
		
		Global.debugsteer[bcs0]["Process exec"][bcs1]["Global is_battle_end false"] = {}
		Global.is_battle_end = false
		
		Global.debugsteer[bcs0]["Process exec"][bcs1]["Main_menu show"] = {}
		show()
		
		print(Global.debugsteer)


func _on_video_stream_player_finished():
	get_parent().get_node("Intro").visible = false
