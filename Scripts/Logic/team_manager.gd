extends Node
class_name TeamManager
@onready var robots :Dictionary = {
	"redTeam" : {
		"object" :{},
		"data" : {}
	},
	"blueTeam" : {
		"object" :{},
		"data" : {}
	}
}


@onready var blues = []
@onready var reds = []
@onready var blueEP = 0
@onready var blueHP = 0
@onready var redEP = 0
@onready var redHP = 0
var astar_grid = 0


var mechAction : Dictionary = {}
#var Teams : Team = preload("res://TeamManager/Team.tscn").instantiate()

func _ready():
	_create_team()

func _create_team():
	var teamAmount = 2
	for i in teamAmount:
		var stack : Team = Team.new(i+1, 0, Team.StrongHolds.RED)
		self.add_child(stack)
		

func _on_map_managed_action(robot, value):
	mechAction[robot] = value
