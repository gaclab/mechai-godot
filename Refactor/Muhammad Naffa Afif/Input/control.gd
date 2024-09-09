extends Node2D
class_name ControlLler

@onready var selector = $selector
@onready var _tile_map : Map = get_parent().get_node("Map")
@onready var _on_arena : bool = false
@onready var turn : bool = true
@onready var highlight : Highlight = get_parent().get_node("Map/highlight")
enum ControllerState {MECH_SELECTED,ACTION_SELECTED,TARGET_SELECTED,TILE_SELECTED,FREE}
var State : ControllerState

func _move_selector(pointer:Vector2)->Vector2: #move the selector , can be add other function like for checking object information
	var map_loc = _tile_map.tile_map.local_to_map(pointer-_tile_map.position)
	var selector_loc =  _tile_map.tile_map.map_to_local(map_loc)+_tile_map.position
	if _tile_map.astar.is_insideMap(map_loc):
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
		return Vector2i(0,0)

func _select_object(pointer:Vector2)->Array: #select the object on the pointer position can be add emit signal to call action and send the object
	var map_loc = _tile_map.tile_map.local_to_map(pointer-_tile_map.position)
	var selected_object = _tile_map._tile_data[map_loc]
	#NEED TEAM AND ROBOT PROPERTY
	print(map_loc)
	print(selected_object)
	State = ControllerState.MECH_SELECTED
	return [selected_object,map_loc]

func _select_target(pointer:Vector2)->Array:
	pass
	var map_loc = _tile_map.tile_map.local_to_map(pointer-_tile_map.position)
	if _tile_map._tile_data.find_key(map_loc):
		var selected_target = _tile_map._tile_data[map_loc]
		#NEED TEAM AND ROBOT PROPERTY
		print(selected_target)
		print(map_loc)
		State = ControllerState.TARGET_SELECTED
		return [selected_target,map_loc]
	else :
		print(map_loc)
		State = ControllerState.TILE_SELECTED
		return [map_loc] 

func _on_turn_switched(turnable:bool): #signal from battle
	turn = turnable

#func _ready() -> void:

func _input(event: InputEvent) -> void:
	pass
	if not Engine.is_editor_hint():
		#	#jika input(event) adalah sebuah tombol mouse
		if event is InputEventMouseMotion:
			pass
			selector.position = _move_selector(event.position)
		if event is InputEventMouseButton:
			if event.is_action_pressed('left-click') and _on_arena:
				highlight.move_zone(_select_object(event.position)[1],3)
				
			#WAITING FOR ACTION OPTION, AND TEAM PROPERTY
			
		#if event is InputEventMouseButton:
			#if event.is_action_pressed("left-click"):
				#if battle_manager.get_battle_state() == 4:
					#if !_helper_hover and !_helpper_is_play:
						#lets_select_unit()
				#elif battle_manager.get_battle_state() == 3:
					#get_parent().get_node("Deploy_sound").play()
					#create_robot(gridder)
				##tambahan kondisi tombol diatas
		#if event is InputEventMouseMotion:
			#if astar_grid.is_in_boundsv(local_to_map(event.position-position)):
				#if battle_manager.get_battle_state() == 3:
					#if robot_count < 3:
						#gridder.x = min(max(local_to_map(event.position-position).x, redTeam_deploy_zone.min().x), redTeam_deploy_zone.max().x)
						#gridder.y = min(max(local_to_map(event.position-position).y, redTeam_deploy_zone.min().y), redTeam_deploy_zone.max().y)
						#prerender()
						#$Pergerakan.posisikan_indikator(map_to_local(gridder))
					#else:
						#gridder.x = min(max(local_to_map(event.position-position).x, blueTeam_deploy_zone.min().x), blueTeam_deploy_zone.max().x)
						#gridder.y = min(max(local_to_map(event.position-position).y, blueTeam_deploy_zone.min().y), blueTeam_deploy_zone.max().y)
						#prerender()
						#$Pergerakan.posisikan_indikator(map_to_local(gridder))
				#else:
					#gridder = local_to_map(event.position-position)
					#if _helper_selected_action == "move" and _is_action_selected:
						#if highlight_zone.has(gridder):
							#prerender()
							#$Pergerakan.posisikan_indikator(map_to_local(gridder))
					#if ( 
						#(_helper_selected_action == "attack" and _is_action_selected ) or 
						#(_helper_selected_action == "skill" and _is_action_selected )
					#):
						#if highlight_zone.has(gridder):
							#$Pergerakan.posisikan_indikator(map_to_local(gridder))
					#else :
						#$Pergerakan.posisikan_indikator(map_to_local(gridder))
					#
					##Fixme : robot info only on battle
					##robot information
					#if robots_manager.robots["redTeam"]["object"].has(gridder):
						#var _temp_robot_info = robots_manager.robots["redTeam"]["object"][gridder].get_robot_datas()
						#robot_information.set_info(_temp_robot_info)
						#if get_parent().get_node("Container").visible == false :
							#get_parent().get_node("Container").visible = true
					#elif robots_manager.robots["blueTeam"]["object"].has(gridder) :
						#var _temp_robot_info = robots_manager.robots["blueTeam"]["object"][gridder].get_robot_datas()
						#robot_information.set_info(_temp_robot_info)
						#if get_parent().get_node("Container").visible == false :
							#get_parent().get_node("Container").visible = true
					#else :
						#if get_parent().get_node("Container").visible == true :
							#get_parent().get_node("Container").visible = false
			#else :
				#if _helper_hover and _is_action_selected:
					#gridder = local_to_map(event.position-position)
					#if _helper_selected_action == "move" and _is_action_selected:
						#if highlight_zone.has(gridder):
							#prerender()
							#$Pergerakan.posisikan_indikator(map_to_local(gridder)) # fix may be causing error in next progress
	#jika input(event) adalah sebuah tombol keyboard
		#if event is InputEventKey:
	##kalkulasi arah gridder berdasarkan input
			#if event.is_action_pressed("ui_up"):
					#gridder += Vector2i.UP
			#elif event.is_action_pressed("ui_right"):
					#gridder += Vector2i.RIGHT
			#elif event.is_action_pressed("ui_left"):
					#gridder += Vector2i.LEFT
			#elif event.is_action_pressed("ui_down"):
					#gridder += Vector2i.DOWN
	##
	##pencegahan agar indikator tidak keluar arena
			#if astar_grid.is_in_boundsv(gridder):
				#$Pergerakan.posisikan_indikator(map_to_local(gridder))
			#else:
				#gridder = local_to_map($Pergerakan.get_posisi_indikator())
	##
	##input ketika indikator memilih robot
			#if event.is_action_pressed("ui_home"):
				#if !_helper_hover and !_helpper_is_play:
					#lets_select_unit()
				##highlight()
	#
	
	#refresh ulang tampilan
			#prerender()
