#extends Node
#class_name BattleNew
#signal TurnSwitched(turn_state:TURN_STATE)
#signal BattleEntered
#enum MODE {CAMPAIGN, MULTIPLAYER,PRACTICE} #UPDATE PRACTICE
#enum CONTROLS {AI_SCRIPT, LIVE_CODE, UI_BUTTON}
#var CONTROLS_NAME: Dictionary= {CONTROLS.AI_SCRIPT: "Ai Script", CONTROLS.LIVE_CODE: "Live Code", CONTROLS.UI_BUTTON: "Ui Button"}
#enum LEVELS {
	#CPLv1, CPLv2, CPLv3, CPLv4, CPLv5,
	#CPLv6, CPLv7, CPLv8, CPLv9, CPLv10,
	#CPLv11, CPLv12, CPLv13, CPLv14, CPLv15
	#}
#enum STATE_SEQUENCE {BATTLE_CREATED,PREPARING, ENTERING, DEPLOYING_OBSTACLE, DEPLOYING_ROBOT, IN_BATTLE, END_BATTLE, IN_RESULT}
#enum TURN_STATE {BLUE,RED,GREEN,YELLOW,ORANGE,VIOLET}
#enum OBSTACLE_TYPE {PLAIN,PREDEFINED,RANDOM} #UPDATE AFIF
#enum ENVIRONMENT_TYPE {DESSERT,GREENLAND,ICELAND,DARKLAND,VALLEYOFDEATH} #UPDATE AFIF opsional perlu pertimbangan
#enum OBJECT_TYPE {ROBOT,OBSTACLE,TILE}
##-- setiap variable memiliki update notifiernya masing masing #-- done
#
##-- turn points timer #-- done
##-- total object info 
##-- #-- time #-- done
##-- #-- who is playing #-- done
##-- #-- total hp & ep & robots
##-- battle prep info
##-- maptype plain/predef
#
##-- konsep signal --> after signal = ambil sendiri
##-- signal based caller
##-- action thread
##-- layer thread
#
##-- else dilarang
##-- nested secukupnya
##-- penggunaan enumerasi
##-- penggunaan update notifier
##-- keep it local
#var campaign_sets: Dictionary= {
	#Battle.LEVELS.CPLv1: {
		#"CONTROLS": Battle.CONTROLS.AI_SCRIPT,
		#"STATUS": false
	#},
	#Battle.LEVELS.CPLv2: {
		#"CONTROLS": Battle.CONTROLS.AI_SCRIPT,
		#"STATUS": false
	#},
	#Battle.LEVELS.CPLv3: {
		#"CONTROLS": Battle.CONTROLS.AI_SCRIPT,
		#"STATUS": false
	#},
	#Battle.LEVELS.CPLv4: {
		#"CONTROLS": Battle.CONTROLS.AI_SCRIPT,
		#"STATUS": false
	#},
	#Battle.LEVELS.CPLv5: {
		#"CONTROLS": Battle.CONTROLS.AI_SCRIPT,
		#"STATUS": false
	#},
	#
	#
	#Battle.LEVELS.CPLv6: {
		#"CONTROLS": Battle.CONTROLS.LIVE_CODE,
		#"STATUS": false
	#},
	#Battle.LEVELS.CPLv7: {
		#"CONTROLS": Battle.CONTROLS.LIVE_CODE,
		#"STATUS": false
	#},
	#Battle.LEVELS.CPLv8: {
		#"CONTROLS": Battle.CONTROLS.LIVE_CODE,
		#"STATUS": false
	#},
	#Battle.LEVELS.CPLv9: {
		#"CONTROLS": Battle.CONTROLS.LIVE_CODE,
		#"STATUS": false
	#},
	#Battle.LEVELS.CPLv10: {
		#"CONTROLS": Battle.CONTROLS.LIVE_CODE,
		#"STATUS": false
	#},
	#
	#
	#Battle.LEVELS.CPLv11: {
		#"CONTROLS": Battle.CONTROLS.UI_BUTTON,
		#"STATUS": false
	#},
	#Battle.LEVELS.CPLv12: {
		#"CONTROLS": Battle.CONTROLS.UI_BUTTON,
		#"STATUS": false
	#},
	#Battle.LEVELS.CPLv13: {
		#"CONTROLS": Battle.CONTROLS.UI_BUTTON,
		#"STATUS": false
	#},
	#Battle.LEVELS.CPLv14: {
		#"CONTROLS": Battle.CONTROLS.UI_BUTTON,
		#"STATUS": false
	#},
	#Battle.LEVELS.CPLv15 : {
		#"CONTROLS": Battle.CONTROLS.UI_BUTTON,
		#"STATUS": false
	#}
#}
#
#var turn_points: Dictionary= {
	#TURN_STATE.BLUE: 5,
	#TURN_STATE.RED: 5,
	#TURN_STATE.GREEN: 30,
	#TURN_STATE.YELLOW: 30,
	#TURN_STATE.ORANGE: 30,
	#TURN_STATE.VIOLET: 30,
#}
#var deploy_conditions : Dictionary = {
	#TURN_STATE.BLUE : false,
	#TURN_STATE.RED : false,
	#TURN_STATE.GREEN: false,
	#TURN_STATE.YELLOW: false,
	#TURN_STATE.ORANGE: false,
	#TURN_STATE.VIOLET: false,
#}
#var battle_status: STATE_SEQUENCE= STATE_SEQUENCE.BATTLE_CREATED:
	#set(val):
		#battle_status = val
		#state_updated.emit(battle_status)
#var turn_state:TURN_STATE = TURN_STATE.BLUE:
	#set(val):
		#turn_state = val
		#TurnSwitched.emit(turn_state)
#var campaign_status: bool= false:
	#set(val):
		#campaign_status = val
		#campaign_done.emit(campaign_status)
#var battle_mode: int= Battle.MODE.MULTIPLAYER:
	#set(val):
		#battle_mode = val
		#mode_updated.emit(battle_mode)
#var battle_control: int= Battle.CONTROLS.UI_BUTTON:
	#set(val):
		#battle_control = val
		#control_updated.emit(battle_control)
#var battle_obstacle:int = Battle.OBSTACLE_TYPE.PLAIN:
	#set(val):
		#battle_obstacle = val
		##print('obstacle type : ',battle_status)
#var battle_environment:int = Battle.ENVIRONMENT_TYPE.GREENLAND:
	#set(val):
		#battle_environment = val
		#environment_updated.emit(battle_environment)
	#
#signal state_updated()
#signal campaign_done(new_status: bool)
#signal mode_updated(new_mode: int)
#signal control_updated(new_control: int)
#signal obstacle_updated(new_obstacle: int)
#signal environment_updated(new_obstacle: int)
#
#var battle_id :String
#var all_players_id : Array
#var R_Heal = 100
#var B_Heal = 100
#var tile_data : Dictionary #AFIF UPDATE
#var map :Map
#var team_manager: TeamManager 
#var control : Controllers
#var obstacle_manager:ObstacleManager
#var turns_timer : Timer
#var preparing_timer : Timer
#var deploying_timer : Timer
#var deploy_zone_ui = preload("res://Scenes/Map/deploy_zone.tscn").instantiate()
#var UIbattle = preload("res://Scenes/UIBattle/UIBattle.tscn").instantiate()
##ga tau penting ngga nya
#var Text :TextEdit
#var label :Label
#var label2 : Label
##=========================
#var winner : Team.StrongHolds
#@export var gridsize :Vector2i = Vector2i(10,10)
#
#func _init(mode:MODE,control:CONTROLS,environment:ENVIRONMENT_TYPE,battle_id:String,all_players_id:Array) -> void: #AFIF UPDATE bingung mau sekalian di init atau pisah redy
	#battle_mode = mode
	#battle_control = control
	#battle_environment = environment
	#self.battle_id = battle_id
	#self.all_players_id = all_players_id
#
##func _input(event: InputEvent) -> void:
	##if event.is_action_pressed("ui_page_down"):
		##print(tile_data)
#
#func time_to_live():
	#if battle_status == STATE_SEQUENCE.IN_BATTLE:
		#var time_left = turns_timer.time_left
		#var minute = floor(time_left / 60)
		#var second = int(time_left) % 60
		#return [minute, second]
	#elif battle_status == STATE_SEQUENCE.DEPLOYING_ROBOT:
		#var time_left = deploying_timer.time_left
		#var minute = floor(time_left / 60)
		#var second = int(time_left) % 60
		#return [minute, second]
#
#func _process(delta: float) -> void:
	#if not Engine.is_editor_hint():
		#if battle_status == STATE_SEQUENCE.DEPLOYING_ROBOT or battle_status == STATE_SEQUENCE.IN_BATTLE:
			#UIbattle.update_time(time_to_live())
			#if battle_status == STATE_SEQUENCE.DEPLOYING_ROBOT:
				#if deploying_timer.time_left > 0.0 and deploying_timer.time_left < 0.2 :
					#print('phe')
					#control._prevent_action_beforeAD()
					#control._auto_deploy() 
			#
#
#func _ready() -> void:
	#Global.on_battle_start()
	#UIbattle.name = 'UIbattle'
	#add_child(UIbattle)
	#if battle_mode == MODE.MULTIPLAYER:
		#_create_multiplayer_battle()
	#elif battle_mode == MODE.CAMPAIGN:
		#_create_campign_battle()
	#elif battle_mode == MODE.PRACTICE:
		#_create_practice_battle()
	#_create_tile_data()
	#_create_deploy_data()
	##declare textedit label and turns_timer
	##prepare timer
	#preparing_timer = Timer.new()
	#preparing_timer.name = 'PreparingTimer'
	#add_child(preparing_timer)
	#preparing_timer.wait_time = 3.0
	#preparing_timer.process_callback = Timer.TIMER_PROCESS_IDLE
	#preparing_timer.timeout.connect(Callable(self,"_on_preparing_timeout"))
	#preparing_timer.one_shot = true
	##==============================
	##deploy timer
	#deploying_timer = Timer.new()
	#deploying_timer.name = 'DeployTimer'
	#add_child(deploying_timer)
	#deploying_timer.wait_time = 15.0
	#deploying_timer.process_callback = Timer.TIMER_PROCESS_IDLE
	#deploying_timer.timeout.connect(Callable(self,"_on_deploying_timeout"))
	##==============================
	##deploy zone
	#deploy_zone_ui.name = 'DeployZone'
	#add_child(deploy_zone_ui)
	#deploy_zone_ui.get_node('Red').hide()
	#deploy_zone_ui.get_node('Blue').hide()
	##==============================
	#turns_timer = Timer.new()
	#turns_timer.name = 'TurnsTimer'
	#add_child(turns_timer)
	#turns_timer.wait_time = 30.0
	#turns_timer.process_callback = Timer.TIMER_PROCESS_IDLE
	#turns_timer.timeout.connect(Callable(self,"_on_turns_timer_timeout"))
	#Text =  TextEdit.new()
	#add_child(Text)
	#label = Label.new()
	#add_child(label)
	#
	#label2 = Label.new()
	#label2.position = Vector2(0,300)
	#add_child(label2)
	#connect('state_updated',Callable(self,"_on_state_updated"))
	#connect('TurnSwitched',Callable(self,"_on_turn_updated"))
	#connect('TurnSwitched',Callable(get_node('TeamManager'),"_on_turn_updated"))
	#connect('TurnSwitched',Callable(get_node('Controller'),"_on_turn_updated"))
	#connect('BattleEntered',Callable(get_node('TeamManager/REDTEAM'),"_on_entering_battle"))
	#connect('BattleEntered',Callable(get_node('TeamManager/BLUETEAM'),"_on_entering_battle"))
	#
	#
	#battle_status = STATE_SEQUENCE.BATTLE_CREATED
#
#func _create_campign_battle():
	##battle_environment = ENVIRONMENT_TYPE.GREENLAND #opsional bisa custom sesuai input menu atau mau didefalut untuk campign
	##campign sets aku ga terlalu paham nunggu diskusi
	#_create_default_battle(battle_obstacle,gridsize,battle_environment)
#
#func _create_multiplayer_battle():
	#pass
	#_create_default_battle(battle_obstacle,gridsize,battle_environment)
#
#func _create_practice_battle():
	#pass #opsional
	#_create_default_battle(battle_obstacle,gridsize,battle_environment)
#
#func _create_default_battle(typeof_obstacle:OBSTACLE_TYPE,map_size:Vector2i,map_environment:ENVIRONMENT_TYPE):
	#map = Map.new(map_size,map_environment)
	#map.name = 'Map'
	#add_child(map)
	#control = Controllers.new(battle_control)
	#control.name = 'Controller'
	#add_child(control)
	#team_manager = TeamManager.new()
	#team_manager.name = 'TeamManager'
	#add_child(team_manager)
	#team_manager.position = map.position
	#if typeof_obstacle != OBSTACLE_TYPE.PLAIN:
		#obstacle_manager = ObstacleManager.new(typeof_obstacle)
		#obstacle_manager.name = 'ObstacleManager'
		#add_child(obstacle_manager)
	##
#func _create_tile_data(): # UPDATE AFIF BUAT DATA NYIMPEN DATA OBJECT DITIAL TILE
	#for x :Vector2i in map.tile_map.get_used_cells():
			#tile_data.merge({x:null})
#
#func _create_deploy_data():
	#for z :Vector2i in map.pra_deploy.get_used_cells():
		#tile_data.merge({z:null})
#
##func update_deploy_data(pos:Vector2i,object:Robot):
	##if tile_data[pos] == null:
		##tile_data[pos] = object
#
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_page_down"):
				#print(Global.battle.tile_data)
#
#func _update_tile_data(current_pos:Vector2i,target_pos:Vector2i,object): # UPDATE AFIF
	#if tile_data[target_pos] == null:
		#if is_instance_of(object,Robot):
			#if battle_status == STATE_SEQUENCE.IN_BATTLE:
				#map.astar.set_Unsolid(current_pos)
				#tile_data[current_pos] = null
			#if battle_status == STATE_SEQUENCE.DEPLOYING_ROBOT:
				#map.astar.set_Unsolid(object.robot_map_loc)
				#tile_data[object.robot_map_loc] = null
			#tile_data[target_pos] = object
			#map.astar.set_Solid(target_pos)
			##print('Tile data update , robot')
		#if is_instance_of(object,Obstacle):
			#tile_data[target_pos] = object
			#map.astar.set_Solid(target_pos)
	##print(tile_data[target_pos])
#
##func test(param:String):
	##label.text = " "
	##if param == 'A':
		##if battle_status == STATE_SEQUENCE.BLUE_PLAYING:
			##R_Heal -= 10
		##elif battle_status == STATE_SEQUENCE.RED_PLAYING:
			##B_Heal -= 10
	##elif param == 'R':
		##state_skip(STATE_SEQUENCE.RED_PLAYING)
	##elif param == 'B':
		##state_skip(STATE_SEQUENCE.BLUE_PLAYING)
	##label.text = str(battle_status) + " " + str(R_Heal) + " " + str(B_Heal) + " " + str(turn_points[STATE_SEQUENCE.BLUE_PLAYING]) + " " + str(turn_points[STATE_SEQUENCE.RED_PLAYING])
#
#func switch_turn(_turn_state: TURN_STATE): # Change by AFIF
		#turn_state = _turn_state
		#UIbattle.update_turn_point(turn_points[TURN_STATE.RED],turn_points[TURN_STATE.BLUE])
		#
#
#func battle_addressor(level_id: int):
	#return campaign_sets[level_id]
#
#
#func get_time():
	#var time_left = turns_timer.time_left
	#var minute = floor(time_left / 60)
	#var second = int(time_left) % 60
	#return [minute, second]
#
#func get_levels():
	#var filtered = {}
	#for i in campaign_sets:
		#if campaign_sets[i].CONTROLS == battle_control:
			#filtered[i] = {"CONTROLS": campaign_sets[i].CONTROLS}
	#return filtered
#
#
#
#func _on_state_updated(now_state:STATE_SEQUENCE) -> void:
	#label2.text = ''
	#label2.text = ' Current Battle State : ' + str(STATE_SEQUENCE.keys()[battle_status]) + ' CURRENT TURN : ' + str(TURN_STATE.keys()[turn_state])
	#if battle_status == STATE_SEQUENCE.BATTLE_CREATED:
		##cuma testing misal nanti mau ditambah animasi ===================
		#await get_tree().create_timer(2.0).timeout 
		#battle_status = STATE_SEQUENCE.PREPARING
		#preparing_timer.start()
	#elif battle_status == STATE_SEQUENCE.ENTERING:
		##cuma testing misal nanti mau ditambah animasi ===================
		#if battle_obstacle != OBSTACLE_TYPE.PLAIN: # pikir nanti dulu
			#get_node('ObstacleManager').deploy_obstacle(battle_obstacle)
			#await get_tree().create_timer(3.0).timeout
			#battle_status = STATE_SEQUENCE.DEPLOYING_OBSTACLE
		#else :
			#await get_tree().create_timer(2.0).timeout
			#battle_status = STATE_SEQUENCE.DEPLOYING_ROBOT
			#deploying_timer.start()
			#deploy_zone_ui.get_node('Red').hide()
			#deploy_zone_ui.get_node('Blue').show()
			#UIbattle.update_turn_point(turn_points[TURN_STATE.RED],turn_points[TURN_STATE.BLUE])
	#elif battle_status == STATE_SEQUENCE.DEPLOYING_OBSTACLE:
		#battle_status = STATE_SEQUENCE.DEPLOYING_ROBOT
		#deploying_timer.start() 
		#deploy_zone_ui.get_node('Red').hide()
		#deploy_zone_ui.get_node('Blue').show()
		#UIbattle.update_turn_point(turn_points[TURN_STATE.RED],turn_points[TURN_STATE.BLUE])
	#elif battle_status == STATE_SEQUENCE.IN_BATTLE:
		##sementara 2 team
		#for i:Robot in get_tree().get_nodes_in_group('RED'):
			#i.change_robot_status(Robot.ROBOT_STATUS.UNTURN)
		#for i:Robot in get_tree().get_nodes_in_group('BLUE'):
			#i.change_robot_status(Robot.ROBOT_STATUS.UNTURN)
		#turns_timer.start()
		#turn_state = TURN_STATE.BLUE
		#UIbattle.update_turn_point(turn_points[TURN_STATE.RED],turn_points[TURN_STATE.BLUE])
	#elif battle_status == STATE_SEQUENCE.END_BATTLE:
		#turns_timer.stop()
		#await get_tree().create_timer(2.0).timeout #animasi end battle
		#battle_status = STATE_SEQUENCE.IN_RESULT
	#elif battle_status == STATE_SEQUENCE.IN_RESULT:
		##sementara disini untuk on result winner, harusnya disini result semua data battle 
		#UIbattle.get_node('Result')._on_battle_manager_battle_ended(Team.StrongHolds.keys()[winner])
		#UIbattle.get_node('Result').show()
	#
#func _on_preparing_timeout():
	#battle_status = STATE_SEQUENCE.ENTERING
	#BattleEntered.emit()
#
#func _on_turn_updated(now_turn:TURN_STATE):
	##print(TURN_STATE.keys()[now_turn])
	#if battle_status == STATE_SEQUENCE.IN_BATTLE:
		#turn_points[now_turn] -= 1
	#else :
		#deploy_conditions[now_turn] = true
	##print(turn_points)
#func _on_end_turn_pressed():
	#if battle_status == STATE_SEQUENCE.IN_BATTLE:
		#turns_timer.stop()
		#turns_timer.timeout.emit()
		#turns_timer.start()
#
#
#
#func _on_deploying_timeout():
	#if deploy_conditions[TURN_STATE.RED] and deploy_conditions[TURN_STATE.RED]:
		#turn_state = TURN_STATE.BLUE
		#battle_status = STATE_SEQUENCE.IN_BATTLE
		#deploying_timer.stop()
		#deploy_zone_ui.queue_free()
	#elif turn_state == TURN_STATE.BLUE:
		#switch_turn(TURN_STATE.RED)
	#elif turn_state == TURN_STATE.RED:
		#switch_turn(TURN_STATE.BLUE)
	#if deploy_conditions[TURN_STATE.BLUE]: # tidak berjalan karena timeout dimulai saat blue telah selesai , duplikasi di state deploy
		#deploy_zone_ui.get_node('Red').hide()
		#deploy_zone_ui.get_node('Blue').show()
	#if deploy_conditions[TURN_STATE.RED]: # berjalan
		#deploy_zone_ui.get_node('Blue').hide()
		#deploy_zone_ui.get_node('Red').show()		
#
#func _on_turns_timer_timeout() -> void:
	#if turn_points[TURN_STATE.RED] <= 0 and turn_points[TURN_STATE.BLUE] <= 0:
		#battle_status = STATE_SEQUENCE.END_BATTLE
	#elif turn_state == TURN_STATE.BLUE and turn_points[TURN_STATE.RED] > 0:
		#switch_turn(TURN_STATE.RED)
	#elif turn_state == TURN_STATE.RED and turn_points[TURN_STATE.BLUE] > 0:
		#switch_turn(TURN_STATE.BLUE)
	#_check_winner()
	#label.text = " "
	#label.text = str(TURN_STATE.keys()[turn_state]) + " " + str(R_Heal) + " " + str(B_Heal) + " " + str(turn_points[TURN_STATE.BLUE]) + " " + str(turn_points[TURN_STATE.RED])
#
##optional code ============================================
#func state_rollup():
	#battle_status += 1
#
#func state_rolldown():
	#battle_status -= 1
#
##func get_playingteam():
	##if battle_status != STATE_SEQUENCE.BLUE_PLAYING and battle_status != STATE_SEQUENCE.RED_PLAYING:
		##print("no one is playing")
	##elif battle_status == STATE_SEQUENCE.BLUE_PLAYING:
		##return STATE_SEQUENCE.BLUE_PLAYING
	##elif battle_status == STATE_SEQUENCE.RED_PLAYING:
		##return STATE_SEQUENCE.RED_PLAYING
#
#func _check_winner()->void:
	#var red_total_hp : int = 0
	#var blue_total_hp : int = 0
	#var red_robot_count : int = 0
	#var blue_robot_count : int = 0
	#var TeamsData = team_manager.TeamsData
	#for team in TeamsData:
		#if team == 'REDTEAM':
			#for robot:Robot in TeamsData[team]['Robots']:
				#red_total_hp += robot.health
				#red_robot_count += 1 if (robot.robotStatus != robot.ROBOT_STATUS.DEATH
				#and robot.robotStatus != robot.ROBOT_STATUS.DESTROYED) else 0
		#elif team == 'BLUETEAM':
			#for robot:Robot in TeamsData[team]['Robots']:
				#blue_total_hp += robot.health
				#blue_robot_count += 1 if (robot.robotStatus != robot.ROBOT_STATUS.DEATH
				#and robot.robotStatus != robot.ROBOT_STATUS.DESTROYED) else 0
	#print(TeamsData)
	#if red_robot_count == 0 :
		#battle_status = STATE_SEQUENCE.END_BATTLE
		#winner = Team.StrongHolds.BLUE
		#return
	#elif blue_robot_count == 0 :
		#battle_status = STATE_SEQUENCE.END_BATTLE
		#winner = Team.StrongHolds.RED
		#return
	#if not red_robot_count == blue_robot_count:
		#winner = Team.StrongHolds.RED if red_robot_count > blue_robot_count else Team.StrongHolds.BLUE
	#else: 
		#winner = Team.StrongHolds.RED if red_total_hp > blue_total_hp else Team.StrongHolds.NONTEAM if red_total_hp == blue_total_hp else Team.StrongHolds.BLUE
	#return
	#
	#
