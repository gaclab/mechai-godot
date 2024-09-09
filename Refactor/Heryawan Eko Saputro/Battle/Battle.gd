extends Node2D
class_name Battle

enum MODE {CAMPAIGN, MULTIPLAYER}
enum CONTROLS {AI_SCRIPT, LIVE_CODE, UI_BUTTON}
var CONTROLS_NAME: Dictionary= {CONTROLS.AI_SCRIPT: "Ai Script", CONTROLS.LIVE_CODE: "Live Code", CONTROLS.UI_BUTTON: "Ui Button"}
enum LEVELS {
	CPLv1, CPLv2, CPLv3, CPLv4, CPLv5,
	CPLv6, CPLv7, CPLv8, CPLv9, CPLv10,
	CPLv11, CPLv12, CPLv13, CPLv14, CPLv15
	}
enum STATE_SEQUENCE {OFFLINE, PREPARING, ENTERING, DEPLOYING_OBSTACLE, DEPLOYING_ROBOT, IN_BATTLE, BLUE_PLAYING, RED_PLAYING, END_BATTLE, IN_RESULT}
#-- setiap variable memiliki update notifiernya masing masing #-- done

#-- turn points timer #-- done
#-- total object info 
#-- #-- time #-- done
#-- #-- who is playing #-- done
#-- #-- total hp & ep & robots
#-- battle prep info
#-- maptype plain/predef

#-- konsep signal --> after signal = ambil sendiri
#-- signal based caller
#-- action thread
#-- layer thread

#-- else dilarang
#-- nested secukupnya
#-- penggunaan enumerasi
#-- penggunaan update notifier
#-- keep it local
var campaign_sets: Dictionary= {
	Battle.LEVELS.CPLv1: {
		"CONTROLS": Battle.CONTROLS.AI_SCRIPT,
		"STATUS": false
	},
	Battle.LEVELS.CPLv2: {
		"CONTROLS": Battle.CONTROLS.AI_SCRIPT,
		"STATUS": false
	},
	Battle.LEVELS.CPLv3: {
		"CONTROLS": Battle.CONTROLS.AI_SCRIPT,
		"STATUS": false
	},
	Battle.LEVELS.CPLv4: {
		"CONTROLS": Battle.CONTROLS.AI_SCRIPT,
		"STATUS": false
	},
	Battle.LEVELS.CPLv5: {
		"CONTROLS": Battle.CONTROLS.AI_SCRIPT,
		"STATUS": false
	},
	
	
	Battle.LEVELS.CPLv6: {
		"CONTROLS": Battle.CONTROLS.LIVE_CODE,
		"STATUS": false
	},
	Battle.LEVELS.CPLv7: {
		"CONTROLS": Battle.CONTROLS.LIVE_CODE,
		"STATUS": false
	},
	Battle.LEVELS.CPLv8: {
		"CONTROLS": Battle.CONTROLS.LIVE_CODE,
		"STATUS": false
	},
	Battle.LEVELS.CPLv9: {
		"CONTROLS": Battle.CONTROLS.LIVE_CODE,
		"STATUS": false
	},
	Battle.LEVELS.CPLv10: {
		"CONTROLS": Battle.CONTROLS.LIVE_CODE,
		"STATUS": false
	},
	
	
	Battle.LEVELS.CPLv11: {
		"CONTROLS": Battle.CONTROLS.UI_BUTTON,
		"STATUS": false
	},
	Battle.LEVELS.CPLv12: {
		"CONTROLS": Battle.CONTROLS.UI_BUTTON,
		"STATUS": false
	},
	Battle.LEVELS.CPLv13: {
		"CONTROLS": Battle.CONTROLS.UI_BUTTON,
		"STATUS": false
	},
	Battle.LEVELS.CPLv14: {
		"CONTROLS": Battle.CONTROLS.UI_BUTTON,
		"STATUS": false
	},
	Battle.LEVELS.CPLv15 : {
		"CONTROLS": Battle.CONTROLS.UI_BUTTON,
		"STATUS": false
	}
}

var turn_points: Dictionary= {
	STATE_SEQUENCE.BLUE_PLAYING: 30,
	STATE_SEQUENCE.RED_PLAYING: 30
}
var battle_status: int= STATE_SEQUENCE.BLUE_PLAYING:
	set(val):
		battle_status = val
		state_updated.emit(self)
var campaign_status: bool= false:
	set(val):
		campaign_status = val
		campaign_done.emit(campaign_status)
var battle_mode: int= Battle.MODE.MULTIPLAYER:
	set(val):
		battle_mode = val
		mode_updated.emit(battle_mode)
var battle_control: int= Battle.CONTROLS.UI_BUTTON:
	set(val):
		battle_control = val
		control_updated.emit(battle_control)

signal state_updated(battle: Battle)
signal turn_used(battle: Battle)
signal campaign_done(new_status: bool)
signal mode_updated(new_mode: int)
signal control_updated(new_control: int)


var R_Heal = 100
var B_Heal = 100
func test(param:String):
	$Label.text = " "
	if param == 'A':
		if battle_status == STATE_SEQUENCE.BLUE_PLAYING:
			R_Heal -= 10
		elif battle_status == STATE_SEQUENCE.RED_PLAYING:
			B_Heal -= 10
	elif param == 'R':
		state_skip(STATE_SEQUENCE.RED_PLAYING)
	elif param == 'B':
		state_skip(STATE_SEQUENCE.BLUE_PLAYING)
	$Label.text = str(battle_status) + " " + str(R_Heal) + " " + str(B_Heal) + " " + str(turn_points[STATE_SEQUENCE.BLUE_PLAYING]) + " " + str(turn_points[STATE_SEQUENCE.RED_PLAYING])

func _input(event):
	if event.is_action_pressed("ui_accept"):
		$turns_timer.start()
		#test($TextEdit.text)




func use_turn(team_state: int):
	turn_points[team_state] -= 1
	turn_used.emit(self)

func state_rollup():
	battle_status += 1

func state_rolldown():
	battle_status -= 1

func state_skip(state_sequence: int):
	if battle_status == state_sequence:
		return
	else:
		battle_status = state_sequence

func battle_addressor(level_id: int):
	return campaign_sets[level_id]


func get_time():
	var time_left = $turns_timer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]

func get_levels():
	var filtered = {}
	for i in campaign_sets:
		if campaign_sets[i].CONTROLS == battle_control:
			filtered[i] = {"CONTROLS": campaign_sets[i].CONTROLS}
	return filtered

func get_playingteam():
	if battle_status != STATE_SEQUENCE.BLUE_PLAYING and battle_status != STATE_SEQUENCE.RED_PLAYING:
		print("no one is playing")
	elif battle_status == STATE_SEQUENCE.BLUE_PLAYING:
		return STATE_SEQUENCE.BLUE_PLAYING
	elif battle_status == STATE_SEQUENCE.RED_PLAYING:
		return STATE_SEQUENCE.RED_PLAYING

func _on_state_updated(battle: Battle) -> void:
	if battle_status == STATE_SEQUENCE.BLUE_PLAYING:
		use_turn(STATE_SEQUENCE.BLUE_PLAYING)
	elif battle_status == STATE_SEQUENCE.RED_PLAYING:
		use_turn(STATE_SEQUENCE.RED_PLAYING)

func _on_turn_used(battle: Battle) -> void:
	print(battle.turn_points)

#-- trial
func _on_turns_timer_timeout() -> void:
	if turn_points[STATE_SEQUENCE.RED_PLAYING] <= 0 and turn_points[STATE_SEQUENCE.BLUE_PLAYING] <= 0:
		get_tree().quit()
	elif battle_status == STATE_SEQUENCE.BLUE_PLAYING and turn_points[STATE_SEQUENCE.RED_PLAYING] > 0:
		state_skip(STATE_SEQUENCE.RED_PLAYING)
	elif battle_status == STATE_SEQUENCE.RED_PLAYING and turn_points[STATE_SEQUENCE.BLUE_PLAYING] > 0:
		state_skip(STATE_SEQUENCE.BLUE_PLAYING)
	$Label.text = " "
	$Label.text = str(battle_status) + " " + str(R_Heal) + " " + str(B_Heal) + " " + str(turn_points[STATE_SEQUENCE.BLUE_PLAYING]) + " " + str(turn_points[STATE_SEQUENCE.RED_PLAYING])
