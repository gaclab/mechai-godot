extends Node
class_name Robots_Manager
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
var mechAction : Dictionary = {}


func _ready():
	#print(_get_winner_on_time_out(totalHp))
	pass
	

func _on_map_managed_action(robot, value):
	mechAction[robot] = value
