extends Node2D
class_name Controllers

var selector :Node2D
var tile_map : Map
@onready var _on_arena : bool = false
@onready var turn : bool = true
var highlight :Node2D
enum ControllerState {MECH_SELECTED,ACTION_SELECTED,TARGET_SELECTED,OBSTACLE_SELECTED,TILE_SELECTED,FREE}
enum BattleType {LOCAL,PVP}
var State : ControllerState : 
	set(val):
		State = val
		print(ControllerState.keys()[State])
var Controller :Node2D
var _helper_pointer :bool = false
var _helper_selected_action :String = ""
var _is_action_selected : bool = false
var selected_object : Node2D
var _temp_selected_loc : Vector2i # menyimpan lokasi sebelumnya dari objek yang diselect guna deploy
var _temp_deploy_loc: Vector2i
var _helper_deployed : bool # kondisi ketika robot ditarik dari tile deploy dan masuk arena
var _helper_deployed_arena :bool # kondisi ketika robot sudah dideploy dan berada dalam map
var _helper_drag_deploy : bool
var _helper_selected_type : Battle.OBJECT_TYPE #untuk menyimpan tipe selected object yang sekarang
var window_size
func _init(controls:Battle.CONTROLS) -> void:
	pass
	if controls == Battle.CONTROLS.UI_BUTTON :
		_create_ui_control()
	elif controls == Battle.CONTROLS.LIVE_CODE :
		_create_lc_control()
	elif controls == Battle.CONTROLS.AI_SCRIPT :
		_create_ai_control()
	selector = preload("res://Scenes/Control/selector.tscn").instantiate()
	add_child(selector)
	highlight = preload("res://Scenes/Highlight/highlight.tscn").instantiate()
	add_child(highlight)
func _ready() -> void:
	tile_map = get_parent().get_node('Map')
	#window_size = get_window().size
	#window_size += Vector2i(2,2)

	
func _move_selector(pointer:Vector2)->Vector2: #move the selector , can be add other function like for checking object information
	var map_loc = tile_map.tile_map.local_to_map(pointer-tile_map.position)
	var selector_loc =  tile_map.tile_map.map_to_local(map_loc)+tile_map.position
	if tile_map.astar.is_insideMap(map_loc):
		if !selector.visible :
			selector.show()
		if !_on_arena:
			_on_arena = true
		return selector_loc
	else :
		if selector.visible :
			selector.hide()
		if _on_arena:
			_on_arena = false
		#if Controller.visible:
			##await get_tree().create_timer(2.0).timeout
			#Controller.hide()
		return Vector2i(0,0)

func _move_selector_deploy(pointer:Vector2)->Vector2: #move the selector , can be add other function like for checking object information
	if !_helper_drag_deploy :
		var map_loc = tile_map.pra_deploy.local_to_map(pointer - tile_map.position)
		var selector_loc =  tile_map.pra_deploy.map_to_local(map_loc) + tile_map.position
		if map_loc in tile_map.pra_deploy.get_used_cells():
			if !selector.visible :
				selector.show()
			if !_on_arena:
				_on_arena = true
			return selector_loc
		else :
			if selector.visible :
				selector.hide()
			if _on_arena:
				_on_arena = false
		return Vector2i.ZERO
	else:
		var map_loc = tile_map.tile_map.local_to_map(pointer-tile_map.position)
		var selector_loc =  tile_map.tile_map.map_to_local(map_loc)+tile_map.position
		if tile_map.astar.is_insideMap(map_loc) and tile_map._is_inside_zone(Global.battle.turn_state,map_loc):
			if !selector.visible :
				selector.show()
			if !_on_arena:
				_on_arena = true
			#print(map_loc)
			_temp_deploy_loc = map_loc
			_helper_deployed = true
			return selector_loc
		elif !tile_map.astar.is_insideMap(map_loc) and tile_map._is_inside_zone(Global.battle.turn_state,map_loc):
			#jika player menarik kembali ke bagian predeploy loc
			if !selector.visible :
				selector.show()
			if !_on_arena:
				_on_arena = true
			#print(map_loc)
			_temp_deploy_loc = map_loc
			_helper_deployed = true
			return selector_loc
		else :
			if selector.visible :
				selector.hide()
			if _on_arena:
				_on_arena = false
			_helper_deployed = false
			_temp_deploy_loc = _random_auto_deploy() # sementara
		#if Controller.visible:
			##await get_tree().create_timer(2.0).timeout
			#Controller.hide()
		return Vector2i.ZERO

func _prevent_action_beforeAD():
	_helper_drag_deploy = false
	if selected_object != null :
		retrive_object_pos(selected_object,_temp_selected_loc)
	selected_object = null
	_temp_selected_loc = Vector2i.ZERO

func _auto_deploy():
	if Global.battle.turn_state == Battle.TURN_STATE.RED:
		for robot:Robot in Global.battle.team_manager.TeamsData['REDTEAM']['Robots']:
			if robot.robot_map_loc not in tile_map.tile_map.get_used_cells():
				robot.get_parent().deploy_robot(robot,_random_auto_deploy())
	elif Global.battle.turn_state == Battle.TURN_STATE.BLUE:
		for robot:Robot in Global.battle.team_manager.TeamsData['BLUETEAM']['Robots']:
			if robot.robot_map_loc not in tile_map.tile_map.get_used_cells():
				robot.get_parent().deploy_robot(robot,_random_auto_deploy())
				
func _random_auto_deploy()->Vector2i:
	var new_zone : Array
	var rand_place
	if Global.battle.turn_state == Battle.TURN_STATE.RED :
		for x in tile_map.red_deploy_zone:
			if x in tile_map.tile_map.get_used_cells():
				new_zone = new_zone + [x]
	elif Global.battle.turn_state == Battle.TURN_STATE.BLUE :
		for x in tile_map.blue_deploy_zone:
			if x in tile_map.tile_map.get_used_cells():
				new_zone = new_zone + [x]
	while true:
		rand_place = randi_range(0,len(new_zone)-1)
		if !tile_map.astar.is_point_solid(new_zone[rand_place]):
			return new_zone[rand_place]
			break # konyol tidak bakal break :v
	return Vector2i.ZERO # sedikit bahaya tapi tidak mungkin 1 zone penuh

func _select_object_deploy(pointer:Vector2):
	
	var map_loc :Vector2i = tile_map.pra_deploy.local_to_map(pointer - tile_map.position) as Vector2i
	if tile_map.astar.is_insideMap(map_loc) or Global.battle.tile_data.has(map_loc):
		if Global.battle.tile_data[map_loc] != null:
			if Global.battle.tile_data[map_loc].get_parent().name == Battle.TURN_STATE.keys()[Global.battle.turn_state] + 'TEAM':
				selected_object = Global.battle.tile_data[map_loc]
				_temp_selected_loc = map_loc
				if selected_object.robotStatus == Robot.ROBOT_STATUS.DEPLOYED:
					_helper_deployed_arena = true
				else:
					_helper_deployed_arena = false

func _create_ui_control():
	pass
	print('ui button')
	var UIcontrol = preload("res://Scenes/Control/UIControl/action_option.tscn").instantiate()
	UIcontrol.name = 'UIControl'
	add_child(UIcontrol)
	Controller = get_node(str(UIcontrol))
	Controller.hide()
func _create_ai_control():
	print('ai scripts')
	pass
func _create_lc_control():
	print('live code')
	pass

func _select_object(pointer:Vector2): #select the object on the pointer position can be add emit signal to call action and send the object
		
	var map_loc = tile_map.tile_map.local_to_map(pointer-tile_map.position)
	var selected_object_temp = Global.battle.tile_data[map_loc]
	if selected_object_temp != null :
		if ((Global.battle.turn_state == Battle.TURN_STATE.RED and selected_object_temp.get_parent().name == 'BLUETEAM') or
		 (Global.battle.turn_state == Battle.TURN_STATE.BLUE and selected_object_temp.get_parent().name == 'REDTEAM')):
			return
	highlight.clear()
	#print(selected_object_temp)
	#print(Global.battle.tile_data)
	#NEED TEAM AND ROBOT PROPERTY
	if selected_object_temp == null :
		if State == ControllerState.MECH_SELECTED:
			Controller.hide()
		State = ControllerState.TILE_SELECTED
		_helper_selected_type = Global.battle.OBJECT_TYPE.TILE
		return
	else:
		selected_object = selected_object_temp
		if is_instance_of(selected_object_temp,Robot):
			State = ControllerState.MECH_SELECTED
			_helper_selected_type = Global.battle.OBJECT_TYPE.ROBOT
			if Global.battle.turn_state == Battle.TURN_STATE.RED and selected_object.get_parent().name == 'REDTEAM' and selected_object.robotStatus != Robot.ROBOT_STATUS.DEATH:
				Controller.show()
				#print('cek visible : ',Controller.get_node('move').visible , ' ',Controller.get_node('move').visible,' ',Controller.get_node('move').visible)
				Controller.get_node('move').visible = selected_object.actionPoint['move']
				Controller.get_node('attack').visible = selected_object.actionPoint['attack']
				Controller.get_node('skill').visible = selected_object.actionPoint['skill']
				var robot_energy = selected_object.energy
				if not (robot_energy >= selected_object.moveEnergy):
					Controller.get_node('move').visible = false
				if not (robot_energy >= selected_object.attackEnergy):
					Controller.get_node('attack').visible = false
				if not (robot_energy >= selected_object.skillEnergy):
					Controller.get_node('skill').visible = false
				Controller.position = tile_map.tile_map.map_to_local(map_loc)+tile_map.position+Vector2(32,-32)
			if Global.battle.turn_state == Battle.TURN_STATE.BLUE and selected_object.get_parent().name == 'BLUETEAM'and selected_object.robotStatus != Robot.ROBOT_STATUS.DEATH:
				Controller.show()
				Controller.get_node('move').visible = selected_object.actionPoint['move']
				Controller.get_node('attack').visible = selected_object.actionPoint['attack']
				Controller.get_node('skill').visible = selected_object.actionPoint['skill']
				var robot_energy = selected_object.energy
				if not (robot_energy >= selected_object.moveEnergy):
					Controller.get_node('move').visible = false
				if not (robot_energy >= selected_object.attackEnergy):
					Controller.get_node('attack').visible = false
				if not (robot_energy >= selected_object.skillEnergy):
					Controller.get_node('skill').visible = false
				Controller.position = tile_map.tile_map.map_to_local(map_loc)+tile_map.position+Vector2(32,-32)
		elif is_instance_of(selected_object_temp,Obstacle):
			State = ControllerState.OBSTACLE_SELECTED
			_helper_selected_type = Global.battle.OBJECT_TYPE.OBSTACLE
		#UPDATE
		return
		
func _get_info(pointer) :
	var map_loc = tile_map.tile_map.local_to_map(pointer-tile_map.position)
	if tile_map.astar.is_insideMap(map_loc):
		var selected_object_temp = Global.battle.tile_data[map_loc]
		if is_instance_of(selected_object_temp,Robot):
			Global.battle.UIbattle.get_node('ObjectInfo').show()
			Global.battle.UIbattle.get_node('ObjectInfo').update_information(selected_object_temp.get_data())
		else:
			Global.battle.UIbattle.get_node('ObjectInfo').hide()

func _select_target(pointer:Vector2)->Array:
	highlight.clear()
	var map_loc = tile_map.tile_map.local_to_map(pointer-tile_map.position)
	if Global.battle.tile_data[map_loc]:
		var selected_target = Global.battle.tile_data[map_loc]
		#NEED TEAM AND ROBOT PROPERTY
		State = ControllerState.TARGET_SELECTED
		return [selected_target,map_loc]
	else :
		#var selected_target = Global.battle.tile_data[map_loc]
		var selected_target = null
		State = ControllerState.TILE_SELECTED
		return [selected_target,map_loc]

func _on_turn_updated(turnable:bool): #signal from battle
	turn = turnable
	if Global.battle.battle_status == Battle.STATE_SEQUENCE.DEPLOYING_ROBOT:
		if _helper_drag_deploy and selected_object != null:
			retrive_object_pos(selected_object,_temp_selected_loc)
		_helper_drag_deploy = false
	Controller.hide()
	selected_object = null
	highlight.clear()
	_is_action_selected = false
	_helper_selected_action = ''
	_helper_pointer = false

#func _ready() -> void:
func retrive_object_pos(object,default_pos):
	object.position = tile_map.pra_deploy.map_to_local(default_pos) 
	#Global.battle._update_tile_data(Vector2(0,0),default_pos,object)
func _get_map_loc(pointer:Vector2):
	return tile_map.tile_map.local_to_map(pointer-tile_map.position)

func _input(event: InputEvent) -> void:
	pass
	if not Engine.is_editor_hint():
		#	#jika input(event) adalah sebuah tombol mouse
		#lokal battle for test
		if event is InputEventMouseMotion:
			pass
			#if !_helper_pointer and _helper_selected_action == "":
			if Global.battle.battle_status == Battle.STATE_SEQUENCE.IN_BATTLE:
				selector.position = _move_selector(event.position)
				_get_info(event.position)
				#pass
			elif Global.battle.battle_status == Battle.STATE_SEQUENCE.DEPLOYING_ROBOT:
				selector.position = _move_selector_deploy(event.position)
			
			if _helper_drag_deploy and Global.battle.battle_status == Battle.STATE_SEQUENCE.DEPLOYING_ROBOT :
				if Global.battle.turn_state == Battle.TURN_STATE.RED and selected_object.get_parent().name == 'REDTEAM':
					selected_object.position = event.position - tile_map.position
				if Global.battle.turn_state == Battle.TURN_STATE.BLUE and selected_object.get_parent().name == 'BLUETEAM':
					selected_object.position = event.position - tile_map.position
		if event is InputEventMouseButton:
			if event.is_action_pressed('left-click') and _on_arena and !_helper_pointer:
				#highlight.move_zone(_select_object(event.position)[1],3)
				if State == ControllerState.ACTION_SELECTED and highlight.get_used_cells().has(_get_map_loc(event.position)):
					var target = _select_target(event.position)
					if _helper_selected_action == "move":
						selected_object.move_robot(Global.battle.map.tile_map.local_to_map(selected_object.position),_get_map_loc(event.position))
					elif _helper_selected_action == "attack":
						if is_instance_of(target[0],Robot):
							if target[0].get_parent().name != Global.battle.TURN_STATE.keys()[Global.battle.turn_state] + 'TEAM' :
								selected_object.attack_enemy(target[0])
							else :
								_select_object(event.position)
						elif is_instance_of(target[0],Obstacle):
							selected_object.attack_obstacle(target[0],false)
					elif _helper_selected_action == "skill":
						selected_object.use_skill(target[0],target[1])
				else :
					if Global.battle.battle_status == Global.battle.STATE_SEQUENCE.IN_BATTLE:
						_select_object(event.position)
			if event.is_action_pressed("left-click") and Global.battle.battle_status == Battle.STATE_SEQUENCE.DEPLOYING_ROBOT:
				_select_object_deploy(event.position)
				if selected_object != null :
					_helper_drag_deploy = true
			if event.is_action_released("left-click") and Global.battle.battle_status == Battle.STATE_SEQUENCE.DEPLOYING_ROBOT:
				_helper_drag_deploy = false
				if ( _helper_deployed or _helper_deployed_arena ) and selected_object != null:
					if Global.battle.tile_data[_temp_deploy_loc] == null :
						selected_object.get_parent().deploy_robot(selected_object,_temp_deploy_loc)
						Global.battle.tile_data[_temp_selected_loc] = null
						selected_object = null
						_temp_selected_loc = Vector2i.ZERO
					else :
						retrive_object_pos(selected_object,_temp_selected_loc)
						selected_object = null
						_temp_selected_loc = Vector2i.ZERO
				else :
					if selected_object != null :
						retrive_object_pos(selected_object,_temp_selected_loc)
						selected_object = null
						_temp_selected_loc = Vector2i.ZERO
			
			#online battle next stage
				#if State == ControllerState.ACTION_SELECTED and highlight.get_used_cells().has(_get_map_loc(event.position)):
					#var target = _select_target(event.position)
					#if _helper_selected_action == "move":
						#selected_object.move_robot(Global.battle.map.tile_map.local_to_map(selected_object.position),_get_map_loc(event.position))
					#elif _helper_selected_action == "attack":
						#if is_instance_of(target[0],Robot):
							#selected_object.attack_enemy(target[0])
						#elif is_instance_of(target[0],Obstacle):
							#selected_object.attack_obstacle(target[0])
					#elif _helper_selected_action == "skill":
						#selected_object.use_skill(target[0],target[1])
				#else :
					#_select_object(event.position)
			#=======================================================================
func _on_pointer_each_option(condition):
	_helper_pointer = condition

func _on_pointer_selected_action(value):
	_helper_selected_action = value
	if Controller.is_visible_in_tree():
		if _helper_selected_action == "move" and is_instance_of(selected_object,Robot):
			if selected_object.actionPoint['move']:
				var action_range = selected_object.moveRange
				#print(selected_object.energy)
				if selected_object.energy <= action_range :
					highlight.move_zone(selected_object.robot_map_loc,selected_object.energy)
				else: 
					highlight.move_zone(selected_object.robot_map_loc,selected_object.moveRange)
					#print(_helper_selected_action)
				_is_action_selected = true
				Controller.visible = false
				State = ControllerState.ACTION_SELECTED
		elif _helper_selected_action == "attack" and is_instance_of(selected_object,Robot):
			if selected_object.actionPoint['attack']:
				highlight.attack_zone(selected_object.robot_map_loc,selected_object.attackRange)
				#print(_helper_selected_action)
				_is_action_selected = true
				Controller.visible = false
				State = ControllerState.ACTION_SELECTED
		elif _helper_selected_action == "skill" and is_instance_of(selected_object,Robot):
			if selected_object.actionPoint['skill']:
				highlight.skill_zone(selected_object.robot_map_loc,selected_object.skillRange)
				#print(_helper_selected_action)
				_is_action_selected = true
				Controller.visible = false
				State = ControllerState.ACTION_SELECTED
			#highlight(
				#local_to_map($Pergerakan.target_yang_dipindahkan.position),
				 #_helper_selected_action,
				#robots_manager.robots[team]["data"][start]["skillRange"]
			
			
