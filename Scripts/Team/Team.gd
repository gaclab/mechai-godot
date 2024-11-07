extends Node2D
class_name Team

enum StrongHolds {RED,BLUE,GREEN,YELLOW,ORANGE,VIOLET,NONTEAM}
enum TeamStates {PREPARING,TURNING,UNTURNING}
var RobotStrongHoldsColor : Array = ['#ffadad','#9bf6ff','#caffbf','#fdffb6','#ffd6a5','#bdb2ff']
var _id : int
var _strongHold : StrongHolds
var team_manager : Dictionary
var _teamState : TeamStates
@onready var _turnPoint : int = 30
var _team_deploy_zone = []
var Robot = preload("res://Scenes/Robot/robot.tscn")
var blue_deploy_pos :PackedVector2Array = [Vector2i(-4,10),Vector2i(-3,10),Vector2i(-2,10)]
var red_deploy_pos :PackedVector2Array = [Vector2i(13,-1),Vector2i(12,-1),Vector2i(11,-1)]
#var Robot = preload("res://TeamManager/unit.tscn").instantiate()
var robotAmount :Dictionary
func _init(battleId:int,playerId:int,strongHolds:StrongHolds,robotAmount:Dictionary):
	_strongHold = strongHolds
	self.robotAmount = robotAmount
	#_id = int(str(battleId) + str(playerId))
	#_teamState = TeamStates.PREPARIN
	#var stack = Robot.duplicate()
	#self.add_child(stack)
	pass


func _on_entering_battle():
	for i in robotAmount:
		var value = robotAmount[i]
		create_robot(i,value)
	print('halo ini diteam dan saat entering')

		
		
func create_robot(i,value):
	var robot = Robot.instantiate()
	robot.name = str(i)
	add_child(robot)
	var initialgenerate :Robot = self.get_node(str(robot.name))
	initialgenerate.custom_init() #for type of robots
	robot.add_to_group(StrongHolds.keys()[_strongHold])
	robot.robotTeam = _strongHold
	get_parent().TeamsData[self.name]['Robots'] += [robot]
	robot.get_node('robot_sprite').modulate = RobotStrongHoldsColor[_strongHold]
	if _strongHold == StrongHolds.RED:
		robot.position = Global.battle.map.pra_deploy.map_to_local(red_deploy_pos[value[0]])+Global.battle.map.pra_deploy.position
		Global.battle._update_tile_data(Vector2i.ZERO,red_deploy_pos[value[0]],robot)
		#print('pheeeee ini red : ',robot.position)
		robot.robot_map_loc = red_deploy_pos[value[0]]
		
	elif _strongHold == StrongHolds.BLUE:
		robot.position = Global.battle.map.pra_deploy.map_to_local(blue_deploy_pos[value[0]])+Global.battle.map.pra_deploy.position
		Global.battle._update_tile_data(Vector2i.ZERO,blue_deploy_pos[value[0]],robot)
		#print('pheeeee ini blue : ',robot.position)
		robot.robot_map_loc = blue_deploy_pos[value[0]]

func deploy_robot(selected:Robot,target_pos:Vector2i):
	#print(target_pos)
	var local_loc = Global.battle.map.tile_map.map_to_local(target_pos)
	selected.position = local_loc
	Global.battle._update_tile_data(Vector2i.ZERO,target_pos,selected)
	selected.change_robot_status(selected.ROBOT_STATUS.DEPLOYED) # error ntah kenapa kalau pakai class name Robot untuk set Robpt statusnya
	selected.robot_map_loc = target_pos
	selected.on_deployed()
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

func set_State(new_state : TeamStates):
	_teamState = new_state
	for i in get_children():
		pass

func get_turnPoint()->int:
	return _turnPoint

func set_turnPoint(new_point : int):
	_turnPoint = new_point

# Called when the node enters the scene tree for the first time.
#func _ready():
	#var test : String = get_strongHoldString()
	#print(test)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
