extends Node2D
class_name TeamManager



var mechAction : Dictionary = {}
var TeamsData : Dictionary = {}

#var Teams : Team = preload("res://TeamManager/Team.tscn").instantiate()

func _init() -> void:
	_create_team(2)
	#UPDATE AFIF opsional aku ga terlalu tau disini buat apa

func _ready():
	#_create_team()
	pass

func _create_team(team_amount):
	for i in team_amount:
		var team_temp : Team = Team.new(i, 0, Team.StrongHolds.values()[i],{"sky":[0,83654],"bluecat":[1,35332],"tigerx":[2,45642]})
		team_temp.name = Team.StrongHolds.keys()[i] + "TEAM"
		self.add_child(team_temp)
		TeamsData.merge({team_temp.name:{'Robots':[]}})
		
func _on_turn_updated(team :Battle.TURN_STATE):
	#print('konek')
	var teamName = Battle.TURN_STATE.keys()[team] + 'TEAM'
	print(teamName)
	for robot:Robot in get_node(teamName).get_children():
		#print('masuk ke robot :' ,robot)
		robot.on_turn_change()

func _on_map_managed_action(robot, value):
	mechAction[robot] = value
