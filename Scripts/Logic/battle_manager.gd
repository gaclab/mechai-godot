class_name BattleManager
extends Node

signal state_changed()
signal battle_ended(value:String)
signal state_switched()

enum BattleState {
	PREPARATION,
	ARENA_ENTRY,
	OBSTACLE_CREATION,
	DEPLOYMENT,
	BATTLE,
	BATTLE_END,
	BATTLE_RESULT
}
var battle_state: int
var battle_log: Array = []
var turn_points: Array = [30,30] # [red, blue] 
var winner: String = ""

@onready var robot_manager = get_parent().get_node("robots_manager")


func get_battle_state() -> int:
	return battle_state


func set_battle_state(state_name: BattleState):
	print(BattleState.PREPARATION)
	print(int(BattleState.PREPARATION))
	match state_name:
		BattleState.PREPARATION:
			battle_state = 0
		BattleState.ARENA_ENTRY:
			battle_state = 1
		BattleState.OBSTACLE_CREATION:
			battle_state = 2
		BattleState.DEPLOYMENT:
			battle_state = 3
		BattleState.BATTLE:
			battle_state = 4
		BattleState.BATTLE_END:
			battle_state = 5
		_:
			battle_state = 6
	state_changed.emit()


func calculate_turn_points(team: String) -> Array:
	if turn_points[0] != 0 or turn_points[1] != 0:
		if team == "redTeam":
			turn_points[0] -= 1
		else:
			turn_points[1] -= 1
	return turn_points


func _get_winner_on_time_out(total_hp: Array, robot_count: Array) -> String:
	var red_team_hp: int = 0
	var blue_team_hp: int = 0 
	var result: String
	
	if not robot_count[0] == robot_count[1]:
		result = "Red Team" if robot_count[0] > robot_count[1] else "Blue Team"
	else: 
		var mid := total_hp.size()/2
		for i in total_hp.size():
			if i < mid:
				red_team_hp += total_hp[i]
			else:
				blue_team_hp += total_hp[i]
		result = "Red Team" if red_team_hp > blue_team_hp else "Draw" if red_team_hp == blue_team_hp else "blue"
	return result


func _ready():
	set_battle_state(BattleState.ARENA_ENTRY)


func _on_turntime_timeout():
	if battle_state == 4:
		state_switched.emit()


func _on_map_ended():
	var total_hp: Array
	var robot_count: Array = [0,0]
	# Todo: shorten the loop and if condition with local var
	for i in robot_manager.robots["redTeam"]["object"]:
		if (robot_manager.robots["redTeam"]["object"][i].robotState == 9 or 
			robot_manager.robots["redTeam"]["object"][i].robotState == 10
		):
			pass
		else :
			robot_count[0] += 1
		total_hp += [robot_manager.robots["redTeam"]["object"][i].get_health()]
	for i in robot_manager.robots["blueTeam"]["object"]:
		if (robot_manager.robots["blueTeam"]["object"][i].robotState == 9 or 
			robot_manager.robots["blueTeam"]["object"][i].robotState == 10
		):
			pass
		else :
			robot_count[1] += 1
		total_hp += [robot_manager.robots["blueTeam"]["object"][i].get_health()]
	battle_ended.emit(_get_winner_on_time_out(total_hp, robot_count))
