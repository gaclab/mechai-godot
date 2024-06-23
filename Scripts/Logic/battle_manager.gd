extends Node
class_name Battle_Manager

# todo : nggak perlu animasi awal

signal changedState()
signal battleended(value:String)
signal switched()
enum BattleState {PREPARATION,ENTERARENA,OBSTACLECREATE,DEPLOYING,BATTLE,BATTLEEND,RESULTBATTLE}
var battleState:int
var battleLog :Array = []
var turnPoint: Array = [15,15] # red | blue 
var winner := ""
@onready var robot_manager = get_parent().get_node("robots_manager")
func get_battle_state()->int:
	return battleState

func set_battle_state(stateName : BattleState):
	match stateName:
		BattleState.PREPARATION :
			battleState = 0
		BattleState.ENTERARENA :
			battleState = 1
		BattleState.OBSTACLECREATE :
			battleState = 2
		BattleState.DEPLOYING :
			battleState = 3
		BattleState.BATTLE :
			battleState = 4
		BattleState.BATTLEEND :
			battleState = 5
		_:
			battleState = 6
	changedState.emit()

func calculate_turn_point(value : String)->Array:
	if turnPoint[0] != 0 or turnPoint[1] != 0 :
		if value == "redTeam" :
			turnPoint[0] -= 1
		else :
			turnPoint[1] -= 1
	return turnPoint


func _get_winner_on_time_out(totalHp : Array,totalRobot : Array)->String:
	var redTeam:int = 0;
	var BlueTeam:int = 0; 
	var result : String
	if totalRobot[0] == totalRobot[1] :
		var switch := totalHp.size()/2
		for i in totalHp.size() :
			if i < switch :
				redTeam += totalHp[i]
			else:
				BlueTeam += totalHp[i]
		result = "red" if redTeam>BlueTeam else "draw" if redTeam == BlueTeam else "blue" 
	else :
		print(totalRobot)
		result = "red" if totalRobot[0]>totalRobot[1] else "blue"
	return result


func _on_preparation_next_state():
	set_battle_state(BattleState.ENTERARENA)


func _on_turntime_timeout():
	if battleState == 4 :
		switched.emit()



func _on_map_ended():
	var totalHp :Array
	var totalRobot : Array = [0,0]
	for i in robot_manager.robots["redTeam"]["object"]:
		if (robot_manager.robots["redTeam"]["object"][i].robotState == 9 or 
			robot_manager.robots["redTeam"]["object"][i].robotState == 10
		):
			pass
		else :
			totalRobot[0] += 1
		totalHp += [robot_manager.robots["redTeam"]["object"][i].get_health()]
	for i in robot_manager.robots["blueTeam"]["object"]:
		if (robot_manager.robots["blueTeam"]["object"][i].robotState == 9 or 
			robot_manager.robots["blueTeam"]["object"][i].robotState == 10
		):
			pass
		else :
			totalRobot[1] += 1
		totalHp += [robot_manager.robots["blueTeam"]["object"][i].get_health()]
	battleended.emit(_get_winner_on_time_out(totalHp,totalRobot))
