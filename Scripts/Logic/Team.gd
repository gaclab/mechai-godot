extends Node
class_name Team

enum StrongHolds {RED,BLUE}
enum TeamStates {PREPARING,TURNING,WAITING}
var _id : int
var _strongHold : int
var team_manager : Dictionary
var _teamState : int
@onready var _turnPoint : int = 30
var _team_deploy_zone = []

var Robot = preload("res://TeamManager/unit.tscn").instantiate()

func _init(battleId:int,playerId:int,strongHolds:StrongHolds):
	_id = int(str(battleId) + str(playerId))
	_strongHold = strongHolds
	_teamState = TeamStates.PREPARING
	var stack = Robot.duplicate()
	self.add_child(stack)

func  get_id()->int:
	return _id

func  get_strongHoldInt()->int:
	return _strongHold

func  get_strongHoldString()->String:
	return StrongHolds.find_key(_strongHold)

func get_stateInt()->int:
	return _teamState

func  get_stateString()->String:
	return TeamStates.find_key(_teamState)

func set_State(new_state : StrongHolds):
	_teamState = new_state

func get_turnPoint()->int:
	return _turnPoint

func set_turnPoint(new_point : int):
	_turnPoint = new_point

# Called when the node enters the scene tree for the first time.
func _ready():
	var test : String = get_strongHoldString()
	print(test)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
