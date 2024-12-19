extends Node
class_name GameControl

@export var arena_size: Vector2i
@export var nested_state_scene: PackedScene
enum game_mode_enum {MULTIPLAYER= 0001, CAMPAIGN= 0002}
enum control_mode_enum {UIBUTTON= 0003}
enum obstacle_mode_enum {PLAIN= 0004, PREDEFINED= 0005, RANDOM= 0006}
enum predefined_map_enum {ANDOR= 0007, HELIOS= 0008, ANDROMEDA= 0009, PERSEUS=0010}
var nested_state: NestedState
var game_mode= game_mode_enum.MULTIPLAYER
var control_mode= control_mode_enum.UIBUTTON
var obstacle_mode= obstacle_mode_enum.PLAIN
var predefined_map= predefined_map_enum.ANDOR
var current_state: Node
var selected_robot: Robot


func prepare():
	nested_state= nested_state_scene.instantiate()
	
	add_child(nested_state)
	
	var state_dict= nested_state.dictionary
	current_state= nested_state.get_state_node(state_dict.OnMainMenu().name)

func roll_state(state= null):
	var root_child= nested_state.get_children()
	if is_instance_valid(state):
		current_state= state
	elif !is_instance_valid(state):
		if current_state.get_child_count():
			var state_found= current_state.get_children()
			current_state= state_found[0]
		elif root_child.has(current_state):
			current_state= find_next_state(current_state)
	state_execute()

func find_next_state(state: Node):
	var state_pointer= state
	var state_found= state_pointer.get_parent().get_children()
	var state_pos= state_found.find(state_pointer)
	while true:
		if state_found.size()-1 > state_pos:
			return state_found[state_pos+1]
		elif state_found.size()-1 == state_pos:
			state_pointer= state_pointer.get_parent()
			state_found= state_pointer.get_parent().get_children()
			state_pos= state_found.find(state_pointer)


func state_execute():
	var state_dict= nested_state.dictionary
	if current_state == nested_state.get_state_node(state_dict.BattleNew().name):
		var arena_material= Control_Core.module_control.arena_builder.arena_material(arena_size, Vector2i(0,0))
		Control_Core.visual_control.arena_tilemap.build_tilemap(arena_material)
		Control_Core.visual_control.battle_environtment.recenter_environtment()
		Control_Core.module_control.team_manager.TakeIn_teams()
		
		Control_Core.visual_control.main_menu.hide()
		Control_Core.visual_control.battle_environtment.show()
		Control_Core.visual_control.arena_tilemap.show()
		Control_Core.visual_control.base_tilemap.show()
		
		roll_state()
	elif current_state == nested_state.get_state_node(state_dict.DeployingRobot().name):
		Control_Core.time_control.start_deploy_timer(10, false)
	#elif current_state == nested_state.get_state_node(state_dict.OnBattle().name):
		#Control_Core.time_control.start_deploy_timer(10, false)

func _input(event: InputEvent) -> void:
	var state_dict= nested_state.dictionary
	if event is InputEventMouseMotion:
		Control_Core.visual_control.selector.event_motion(event.position)
	if current_state == nested_state.get_state_node(state_dict.DeployingRobot().name):
		robot_dragndrop(event)
	elif current_state == nested_state.get_state_node(state_dict.OnBattle().name):
		battle_control(event)

func robot_dragndrop(event: InputEvent):
	if event is InputEventMouseMotion:
		Control_Core.module_control.object_control.drag_selected()
	if event is InputEventMouseButton:
		var state_dict= nested_state.dictionary
		if event.is_action_pressed('left-click') and Control_Core.visual_control.selector.visible:
			var selector= Control_Core.visual_control.selector
			var robot= Control_Core.visual_control.game_object.robot_by_position(selector.gridded_event_position, selector.tilegrid_owner)
			Control_Core.module_control.object_control.select_robot(robot)
			
		elif event.is_action_released('left-click') and Control_Core.visual_control.selector.visible:
			Control_Core.module_control.object_control.select_robot(null)

func battle_control(event: InputEvent):
	if event is InputEventMouseButton:
		if event.is_action_pressed('left-click') and Control_Core.visual_control.selector.visible:
			var selector= Control_Core.visual_control.selector
			var robot= Control_Core.visual_control.game_object.robot_by_position(selector.gridded_event_position, selector.tilegrid_owner)
			Control_Core.module_control.object_control.select_robot_action(robot)

func _on_deploy_timer_timeout() -> void:
	Control_Core.module_control.object_control.select_robot(null)
	roll_state()
