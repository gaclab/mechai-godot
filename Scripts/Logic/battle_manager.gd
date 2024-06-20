extends Node
class_name Battle_Manager

# todo : nggak perlu animasi awal

signal changedState()
signal battleended()
signal switched()
enum BattleState {PREPARATION,ENTERARENA,OBSTACLECREATE,DEPLOYING,BATTLE,BATTLEEND,RESULTBATTLE}
var battleState:int
var battleLog :Array = []
var turnPoint: Array = [30,30] # red | blue 
var totalHp:Array = [4,2,5,7,2,3] #red | blue
var winner := ""

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
	if turnPoint[0] == 0 and turnPoint[1] == 0 :
		battleended.emit()
		print("battleend")

func calculate_turn_point(value : String)->Array:
	if turnPoint[0] != 0 or turnPoint[1] != 0 :
		if value == "redTeam" :
			turnPoint[0] -= 1
		else :
			turnPoint[1] -= 1
	return turnPoint

func check_match_ended():
	if turnPoint[0] == 0 and turnPoint[1] == 0 :
		#kondisi battle end
		winner = _get_winner_on_time_out(totalHp)
		print(winner)

func _get_winner_on_time_out(totalHp : Array)->String:
	var switch := totalHp.size()/2
	var redTeam:int = 0;
	var BlueTeam:int = 0; 
	for i in totalHp.size() :
		if i < switch :
			redTeam += totalHp[i]
		else:
			BlueTeam += totalHp[i]
	var result = "red" if redTeam>BlueTeam  else "blue"
	return result


func _on_preparation_next_state():
	set_battle_state(BattleState.ENTERARENA)


func _on_turntime_timeout():
	if battleState == 4 :
		switched.emit()

