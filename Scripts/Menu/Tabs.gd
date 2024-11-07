extends TabContainer

var debugres: Dictionary = {}
func _ready() -> void:
	debugres["Back click"] = {}
	debugres["Go click"] = {}

func runTo_BattleSetup():	
	#Global.debugsteer[bcs0][entrGate][pipeGate]["Current tab 1 / Battle setup"] = {}
	#Global.debugsteer[bcs0][entrGate][pipeGate]["Current tab 1 / Battle setup"]["Current tab 0 / ModeSelect"] = {}
	
	debugres["Current tab 0 / ModeSelect"] = {}
	current_tab = 0
	
	return debugres

func _on_back_pressed():
	debugres["Back click"]["BattleSetup tab reverse"] = {}
	current_tab -= 1
	
	debugres["Back click"]["Clickb sound play"] = {}
	$clickb.play()


func _on_go_pressed():
	debugres["Go click"]["BattleSetup tab forward"] = {}
	current_tab += 1
	
	debugres["Go click"]["Clicka sound play"] = {}
	$clicka.play()
