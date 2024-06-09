extends Node


var battleLog :Array = []
var mechEnergy :Dictionary = {}
var mechStats : Array = []
var mechAction : Dictionary = {}
var turnPoint: Array = [30,30] # red | blue 
var totalHp:Array = [4,2,5,7,2,3] #red | blue
var winner := ""

func _ready():
	#print(_get_winner_on_time_out(totalHp))
	pass



func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_left"):
			pass
			_calculate_turn_point("red")
		if event.is_action_pressed("ui_right"):
			pass
			_calculate_turn_point("blue")
		#print(turnPoint)


func _calculate_turn_point(value : String)->Array:
	if turnPoint[0] != 0 or turnPoint[1] != 0 :
		if value == "red" :
			turnPoint[0] -= 1
		else :
			turnPoint[1] -= 1
	return turnPoint

func check_match_ended():
	if turnPoint[0] == 0 and turnPoint[1] == 0 :
		#kondisi battle end
		winner = _get_winner_on_time_out(totalHp)
		#print(winner)

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

# ubah 
func _on_map_managed_action(robot, value): 
	mechAction[robot] = value
	



