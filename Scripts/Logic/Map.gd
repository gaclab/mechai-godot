@tool
extends TileMap

signal managed_action(robot : Node2D, value :Array) # nanti diganti ketika sudah ada robot
signal turned(value:String)
signal ended
@onready var actionoption = $"action-option"
@onready var action_option_move = $"action-option/move"
@onready var action_option_attack = $"action-option/attack"
@onready var action_option_skill = $"action-option/skill"
@onready var timeinformation = $Time/timeinformation
@onready var turntime = $turntime
@onready var redpoint = $button_end_turn/Red/HBoxContainer/redpoint
@onready var bluepoint = $button_end_turn/Blue/HBoxContainer/bluepoint
@onready var robots_manager : Node;
@onready var battle_manager : Node;
@onready var obstacle_manager : Node;
var _helper_endturn : bool;
var _helper_multiple :int = 1
var team = "redTeam"
var _is_action_selected : bool # untuk kondisi ketika action dipilih
var _helpper_is_play : bool = false # indikator untuk mencegah aksi ketika robot digerakkan
var _helper_hover:bool = false # indikator supaya selama crusor diatas menu action maka tidak bisa select 
var _temp_action_point : Array = [1,1,1]
var _helper_selected_action : String; # indikator untuk menyimpan action terakhir yang dipilih guna menyesuaikan kebutuhan
var _helper_create_once_obstacle : bool = false # sebagai bantuan agar hanya 1x create obstacle
var gridder = Vector2i(0,0)
var points : Curve2D
var astar_grid = AStarGrid2D.new()
var start = Vector2i(0,0)
var packedpoints : PackedVector2Array
@onready var ukuran_jendela = get_window().size + Vector2i(0,23)
var highlight_zone = []
var redTeam_deploy_zone = []
var blueTeam_deploy_zone = []

var blues = []
var redies = []
var blueEP = 0
var blueHP = 0
var redEP = 0
var redHP = 0

var Obstacle = load("res://Scenes/Main scenes/obstacles.tscn").instantiate()
var robots = load("res://Scenes/robot.tscn").instantiate()
var Multiplayer : Resource = preload("res://Assets/Tres/MultiPlayerObstacle.tres")
@onready var robot_information = get_parent().get_node("Container/VBoxContainer")

#@export var Bake = false :
	#set(val) : generate_ulang_map()
#func generate_ulang_map():
	#clear()
	#position = ((ukuran_jendela) - (tile_set.tile_size*tile_set.mapSize))/2
	#var lokasi_pojok = (-(ukuran_jendela) + (tile_set.tile_size*tile_set.mapSize))/2
	#var lokasi_pojok_snapped = local_to_map(lokasi_pojok)
	#while lokasi_pojok_snapped.y <= local_to_map(ukuran_jendela+lokasi_pojok).y:
		#var tempx = lokasi_pojok_snapped.x
		#while lokasi_pojok_snapped.x <= local_to_map(ukuran_jendela+lokasi_pojok).x:
			#
			#if	(
				#lokasi_pojok_snapped.y >= 0 and lokasi_pojok_snapped.y < tile_set.mapSize.y
				#and 
				#lokasi_pojok_snapped.x >= 0 and lokasi_pojok_snapped.x < tile_set.mapSize.x
				#):
				#set_cell(0,lokasi_pojok_snapped,1,Vector2i(34,1))
			#else:
				#set_cell(1,lokasi_pojok_snapped,1,Vector2i(35,3))
			#
			#lokasi_pojok_snapped.x += 1
		#lokasi_pojok_snapped.y += 1
		#lokasi_pojok_snapped.x = tempx



func highlight(robot_pos:Vector2i, type:String ,range:int):
	if not Engine.is_editor_hint():
		highlight_zone.clear()
		$Highlight.clear()
		var layer_type
		if type == "move" :
			layer_type = 0
		elif type == "attack" :
			layer_type = 1
		elif type == "skill" :
			layer_type = 2
		
		highlight_zone = [robot_pos]
		var outsider = [Vector2i(1,1),Vector2i(-1,-1),Vector2i(-1,1),Vector2i(1,-1)]
		var highlight_range = range
		
		var change_cache = []
		while change_cache != highlight_zone:
			change_cache = highlight_zone
			var highlight_border = []
			for k in outsider:
				for i in highlight_range+1:
					highlight_border += [(Vector2i(highlight_range-i, i)*k)+robot_pos]
					#$Highlight.set_cell(1,highlight_zone[0],0,Vector2i(0,0))
			
			$Highlight.set_cell(layer_type,highlight_zone[0],0,Vector2i(0,0))
			
			for i in highlight_zone:
				if !highlight_border.has(i):
					if !highlight_zone.has(i+Vector2i.UP):
						if astar_grid.is_in_boundsv(i+Vector2i.UP):
							if !astar_grid.is_point_solid(i+Vector2i.UP) and layer_type == 0:
								$Highlight.set_cell(layer_type,i+Vector2i.UP,0,Vector2i(0,0))
								highlight_zone += [i+Vector2i.UP]
							elif astar_grid.is_point_solid(i+Vector2i.UP) and layer_type == 1 :
								if team == "redTeam" and robots_manager.robots["redTeam"]["object"].has(i+Vector2i.UP):
									$Highlight.set_cell(1,i+Vector2i.UP,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.UP]
									astar_grid.set_point_solid(i+Vector2i.UP,true)
								elif team =="blueTeam" and robots_manager.robots["blueTeam"]["object"].has(i+Vector2i.UP):
									$Highlight.set_cell(1,i+Vector2i.UP,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.UP]
									astar_grid.set_point_solid(i+Vector2i.UP,true)
								else:
									$Highlight.set_cell(3,i+Vector2i.UP,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.UP]
									astar_grid.set_point_solid(i+Vector2i.UP,true)
							elif astar_grid.is_point_solid(i+Vector2i.UP) and layer_type == 2 :
								if team == "redTeam" and robots_manager.robots["redTeam"]["object"].has(i+Vector2i.UP):
									$Highlight.set_cell(2,i+Vector2i.UP,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.UP]
									astar_grid.set_point_solid(i+Vector2i.UP,true)
								elif team =="blueTeam" and robots_manager.robots["blueTeam"]["object"].has(i+Vector2i.UP):
									$Highlight.set_cell(2,i+Vector2i.UP,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.UP]
									astar_grid.set_point_solid(i+Vector2i.UP,true)
								else:
									$Highlight.set_cell(3,i+Vector2i.UP,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.UP]
									astar_grid.set_point_solid(i+Vector2i.UP,true)
							elif !astar_grid.is_point_solid(i+Vector2i.UP) :
								$Highlight.set_cell(1,i+Vector2i.UP,0,Vector2i(0,0))
								highlight_zone += [i+Vector2i.UP]
						
					if !highlight_zone.has(i+Vector2i.DOWN):
						if astar_grid.is_in_boundsv(i+Vector2i.DOWN):
							if !astar_grid.is_point_solid(i+Vector2i.DOWN) and layer_type == 0:
								$Highlight.set_cell(layer_type,i+Vector2i.DOWN,0,Vector2i(0,0))
								highlight_zone += [i+Vector2i.DOWN]
							elif astar_grid.is_point_solid(i+Vector2i.DOWN) and layer_type == 1:
								if team == "redTeam" and robots_manager.robots["redTeam"]["object"].has(i+Vector2i.DOWN):
									$Highlight.set_cell(1,i+Vector2i.DOWN,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.DOWN]
									astar_grid.set_point_solid(i+Vector2i.DOWN,true)
								elif team =="blueTeam" and robots_manager.robots["blueTeam"]["object"].has(i+Vector2i.DOWN):
									$Highlight.set_cell(1,i+Vector2i.DOWN,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.DOWN]
									astar_grid.set_point_solid(i+Vector2i.DOWN,true)
								else:
									$Highlight.set_cell(3,i+Vector2i.DOWN,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.DOWN]
									astar_grid.set_point_solid(i+Vector2i.DOWN,true)
							elif astar_grid.is_point_solid(i+Vector2i.DOWN) and layer_type == 2:
								if team == "redTeam" and robots_manager.robots["redTeam"]["object"].has(i+Vector2i.DOWN):
									$Highlight.set_cell(2,i+Vector2i.DOWN,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.DOWN]
									astar_grid.set_point_solid(i+Vector2i.DOWN,true)
								elif team =="blueTeam" and robots_manager.robots["blueTeam"]["object"].has(i+Vector2i.DOWN):
									$Highlight.set_cell(2,i+Vector2i.DOWN,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.DOWN]
									astar_grid.set_point_solid(i+Vector2i.DOWN,true)
								else:
									$Highlight.set_cell(3,i+Vector2i.DOWN,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.DOWN]
									astar_grid.set_point_solid(i+Vector2i.DOWN,true)
							elif !astar_grid.is_point_solid(i+Vector2i.DOWN) :
								$Highlight.set_cell(1,i+Vector2i.DOWN,0,Vector2i(0,0))
								highlight_zone += [i+Vector2i.DOWN]
					
					if !highlight_zone.has(i+Vector2i.LEFT):
						if astar_grid.is_in_boundsv(i+Vector2i.LEFT):
							if !astar_grid.is_point_solid(i+Vector2i.LEFT) and layer_type == 0:
								$Highlight.set_cell(layer_type,i+Vector2i.LEFT,0,Vector2i(0,0))
								highlight_zone += [i+Vector2i.LEFT]
							elif astar_grid.is_point_solid(i+Vector2i.LEFT) and layer_type == 1:
								if team == "redTeam" and robots_manager.robots["redTeam"]["object"].has(i+Vector2i.LEFT):
									$Highlight.set_cell(1,i+Vector2i.LEFT,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.LEFT]
									astar_grid.set_point_solid(i+Vector2i.LEFT,true)
								elif team =="blueTeam" and robots_manager.robots["blueTeam"]["object"].has(i+Vector2i.LEFT):
									$Highlight.set_cell(1,i+Vector2i.LEFT,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.LEFT]
									astar_grid.set_point_solid(i+Vector2i.LEFT,true)
								else:
									$Highlight.set_cell(3,i+Vector2i.LEFT,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.LEFT]
									astar_grid.set_point_solid(i+Vector2i.LEFT,true)
							elif astar_grid.is_point_solid(i+Vector2i.LEFT) and layer_type == 2:
								if team == "redTeam" and robots_manager.robots["redTeam"]["object"].has(i+Vector2i.LEFT):
									$Highlight.set_cell(2,i+Vector2i.LEFT,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.LEFT]
									astar_grid.set_point_solid(i+Vector2i.LEFT,true)
								elif team =="blueTeam" and robots_manager.robots["blueTeam"]["object"].has(i+Vector2i.LEFT):
									$Highlight.set_cell(2,i+Vector2i.LEFT,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.LEFT]
									astar_grid.set_point_solid(i+Vector2i.LEFT,true)
								else:
									$Highlight.set_cell(3,i+Vector2i.LEFT,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.LEFT]
									astar_grid.set_point_solid(i+Vector2i.LEFT,true)
							elif !astar_grid.is_point_solid(i+Vector2i.LEFT) :
								$Highlight.set_cell(1,i+Vector2i.LEFT,0,Vector2i(0,0))
								highlight_zone += [i+Vector2i.LEFT]

					if !highlight_zone.has(i+Vector2i.RIGHT):
						if astar_grid.is_in_boundsv(i+Vector2i.RIGHT):
							if !astar_grid.is_point_solid(i+Vector2i.RIGHT) and layer_type == 0:
								$Highlight.set_cell(layer_type,i+Vector2i.RIGHT,0,Vector2i(0,0))
								highlight_zone += [i+Vector2i.RIGHT]
							elif astar_grid.is_point_solid(i+Vector2i.RIGHT) and layer_type == 1:
								if team == "redTeam" and robots_manager.robots["redTeam"]["object"].has(i+Vector2i.RIGHT):
									$Highlight.set_cell(1,i+Vector2i.RIGHT,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.RIGHT]
									astar_grid.set_point_solid(i+Vector2i.RIGHT,true)
								elif team =="blueTeam" and robots_manager.robots["blueTeam"]["object"].has(i+Vector2i.RIGHT):
									$Highlight.set_cell(1,i+Vector2i.RIGHT,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.RIGHT]
									astar_grid.set_point_solid(i+Vector2i.RIGHT,true)
								else:
									$Highlight.set_cell(3,i+Vector2i.RIGHT,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.RIGHT]
									astar_grid.set_point_solid(i+Vector2i.RIGHT,true)
							elif astar_grid.is_point_solid(i+Vector2i.RIGHT) and layer_type == 2:
								if team == "redTeam" and robots_manager.robots["redTeam"]["object"].has(i+Vector2i.RIGHT):
									$Highlight.set_cell(2,i+Vector2i.RIGHT,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.RIGHT]
									astar_grid.set_point_solid(i+Vector2i.RIGHT,true)
								elif team =="blueTeam" and robots_manager.robots["blueTeam"]["object"].has(i+Vector2i.RIGHT):
									$Highlight.set_cell(2,i+Vector2i.RIGHT,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.RIGHT]
									astar_grid.set_point_solid(i+Vector2i.RIGHT,true)
								else:
									$Highlight.set_cell(3,i+Vector2i.RIGHT,0,Vector2i(0,0))
									highlight_zone += [i+Vector2i.RIGHT]
									astar_grid.set_point_solid(i+Vector2i.RIGHT,true)
							elif !astar_grid.is_point_solid(i+Vector2i.RIGHT):
								$Highlight.set_cell(1,i+Vector2i.RIGHT,0,Vector2i(0,0))
								highlight_zone += [i+Vector2i.RIGHT]
			
		#for g in highlight_zone:
			#if highlight_border.has(g):
				#highlight_zone.erase(g)
				#$Highlight.erase_cell(layer_type,g)
# Todo : Gridder set on ready
func _ready():
	#Ketika script berjalan didalam game
	if not Engine.is_editor_hint():
		#set_cell(1,vesorus[0],1,Vector2i(35,3))
	#
		$Pergerakan.posisikan_indikator(map_to_local(gridder))
		robots_manager = get_parent().get_node("robots_manager")
		battle_manager = get_parent().get_node("battle_manager")
		obstacle_manager = get_parent().get_node("obstacle_manager")
		redpoint.text = str(battle_manager.turnPoint[0])
		bluepoint.text = str(battle_manager.turnPoint[1])
		
		prerender()
		#sembunyikan action option
		actionoption.visible = false
	#inisialisasi astar_grid
		astar_grid.size = tile_set.mapSize # setting ukuran peta
		astar_grid.cell_size = tile_set.cellSize # setting ukuran kolom
		astar_grid.offset = tile_set.cellSize/2 # setting offset astar_grid
		#setting algoritma astar_grid
		astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
		astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
		astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
		#
		astar_grid.update() #update astar_grid
	visible = false
	$Effect.visible = false

# Todo : show is robot deploying
func _process(delta):
	#recount()
	if not Engine.is_editor_hint():
		if time_to_live()[1] >= 10:
			$Time.self_modulate = Color.GREEN
			$Time/Panel.self_modulate = Color.GREEN
		elif time_to_live()[1] >= 1:
			if time_to_live()[1] % 2 == 1:
				$Time.self_modulate = Color.YELLOW
				$Time/Panel.self_modulate = Color.YELLOW
			elif time_to_live()[1] % 2 == 0:
				$Time.self_modulate = Color.BLACK
				$Time/Panel.self_modulate = Color.BLACK

		else:
			$Time.self_modulate = Color.RED
			$Time/Panel.self_modulate = Color.RED
		timeinformation.text = "%02d:%02d" % time_to_live()
# Fixme : on Game only run
		
func time_to_live():
	var time_left = turntime.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]

#todo : Add cant deploy hints
#todo : Add low energy hints
var robot_count = 0
func create_robot(robotpos : Vector2i):
	if robot_count < 6:
		if !astar_grid.is_point_solid(robotpos):
			if robot_count < 3 :
				var unit : robot = robots.duplicate()
				add_child(unit)
				unit.position = map_to_local(robotpos)
				unit.get_node("robot_sprite").modulate = "#fc8070"
				redies = redies + [unit]
				$button_end_turn.redies = $button_end_turn.redies + [unit]
				robots_manager.robots["redTeam"]["object"][local_to_map(unit.position)] =  unit
				robots_manager.robots["redTeam"]["data"][local_to_map(unit.position)] = (
					robots_manager.robots["redTeam"]["object"][local_to_map(unit.position)].get_robot_datas()
				)
				robots_manager.mechAction[unit] = [1,1,1]
				astar_grid.set_point_solid(robotpos)
				unit.connect("death",_on_robot_death)
				unit.connect("destroy",_on_robot_destroy)
			else :
				var unit : robot = robots.duplicate()
				add_child(unit)
				unit.position = map_to_local(robotpos)
				unit.get_node("robot_sprite").modulate = "#86c2ff"
				blues = blues + [unit]
				$button_end_turn.blues = $button_end_turn.blues + [unit]
				robots_manager.robots["blueTeam"]["object"][local_to_map(unit.position)] =  unit
				robots_manager.robots["blueTeam"]["data"][local_to_map(unit.position)] = (
					robots_manager.robots["blueTeam"]["object"][local_to_map(unit.position)].get_robot_datas()
				)
				robots_manager.mechAction[unit] = [1,1,1] # set mechAction in battle manager 
				astar_grid.set_point_solid(robotpos)
				unit.connect("death",_on_robot_death)
				unit.connect("destroy",_on_robot_destroy)
			robot_count += 1
			$button_end_turn.recount()
			if robot_count < 3 :
				$Deployzone.position = Vector2i(map_to_local(redTeam_deploy_zone.min())) - (tile_set.cellSize/2)
				$Deployzone.size = Vector2i(map_to_local(redTeam_deploy_zone.max() - redTeam_deploy_zone.min())) + (tile_set.cellSize/2)
				$Deployzone.modulate = Color.RED
			else :
				$Deployzone.position = Vector2i(map_to_local(blueTeam_deploy_zone.min())) - (tile_set.cellSize/2)
				$Deployzone.size = Vector2i(map_to_local(blueTeam_deploy_zone.max() - blueTeam_deploy_zone.min())) + (tile_set.cellSize/2)
				$Deployzone.modulate = Color.BLUE
	if robot_count == 6:
		for red in redies:
			redHP += red.health
			redEP += red.energy
			$button_end_turn/Blue/HBoxContainer/VBoxContainer/Hp/ProgressBar.value = 100
			$button_end_turn/Blue/HBoxContainer/VBoxContainer/Ep/ProgressBar.value = 100
		for blue in blues:
			blueHP += blue.health
			blueEP += blue.energy
			$button_end_turn/Red/HBoxContainer/VBoxContainer/Hp/ProgressBar.value = 100
			$button_end_turn/Red/HBoxContainer/VBoxContainer/Ep/ProgressBar.value = 100
		battle_manager.set_battle_state(battle_manager.BattleState.BATTLE)
		$Deployzone.visible = false
		$turntime.start()

var preobs = []
func dev_obstacle_editor(robotpos : Vector2i):
	if !astar_grid.is_point_solid(robotpos): #memposisikan setiap obstacle
		var unit : Obstacles = Obstacle.duplicate()
		var sb = unit.get_node("solidbar")
		sb.visible = false
		unit.position = map_to_local(robotpos) #memposisikan setiap obstacle
		add_child(unit) #menambahkan setiap obstacle kedalam tree
		preobs = preobs + [robotpos]
		unit.playanimatedspawn()
		astar_grid.set_point_solid(robotpos)
		await get_tree().create_timer(0.1).timeout

#Fixme obstacle timer is in here
func create_obstacles_multiplayer():
	#bagian generate obstacle
		#generate obstacle in multiplayer
		var obstacleLocation = PackedVector2Array()
		if Global.maptype == 2:
			obstacleLocation = Multiplayer._getMultiplayerLocation(self) #ambil posisi seluruh obstacle
		elif Global.maptype == 1:
			obstacleLocation = Global.premaps[Global.selected_premap]
		Obstacle.get_node("solidbar").visible = false
		for i in obstacleLocation:
			var stack : Obstacles = Obstacle.duplicate() #duplikasi objek obstacle
			var sb = stack.get_node("solidbar")
			sb.visible = false
			stack.position = map_to_local(i) #memposisikan setiap obstacle
			add_child(stack) #menambahkan setiap obstacle kedalam tree
			obstacle_manager.obstacles[Vector2i(i)] = stack
			stack.playanimatedspawn()
			astar_grid.set_point_solid(i,true)
			await get_tree().create_timer(0.1).timeout
		_on_obstacle_timer_timeout()
		
func _attack_target(action:String,attacker :robot, target):
	if _helper_selected_action == "attack" :
		attacker.consume_energy(attacker.attackEnergy,1)
		_temp_action_point[1] = 0
		managed_action.emit(attacker,_temp_action_point)
	elif _helper_selected_action == "skill" :
		attacker.consume_energy(attacker.skillEnergy,1)
		_temp_action_point[2] = 0
		managed_action.emit(attacker,_temp_action_point)
	if is_instance_of(target,robot):
		if _helper_selected_action == "attack":
			target.on_damaged(attacker.attackDamage)
			$Effect.position.x = target.position.x
			$Effect.position.y = target.position.y - 20
			$Effect.visible = true
			$Effect/AnimatedSprite2D.play("Explosion2")
			$turntime.paused = true
			attacker.get_node("attack").play()
			await get_tree().create_timer(0.5).timeout
			$turntime.paused = false
			$Effect.visible = false
			if target.robotState == 10 :
				attacker.health = target.prizeHealth
				attacker.energy = target.prizeEnergy
				attacker.get_new_value_attribute()
		elif _helper_selected_action == "skill":
			target.on_damaged(attacker.skillDamage)
			$Effect.position.x = target.position.x
			$Effect.position.y = target.position.y - 20
			$Effect.visible = true
			$Effect/AnimatedSprite2D.play("Explosion5")
			$turntime.paused = true
			attacker.get_node("skill").play()
			await get_tree().create_timer(0.5).timeout
			$turntime.paused = false
			$Effect.visible = false
			if target.robotState == 10 :
				attacker.health = target.prizeHealth
				attacker.energy = target.prizeEnergy
				attacker.get_new_value_attribute()
	elif is_instance_of(target,Obstacles):
		target.onDamage(1)
		$Effect.position.x = target.position.x
		$Effect.position.y = target.position.y - 20
		$Effect.visible = true
		$Effect/AnimatedSprite2D.play("Explosion1")
		$turntime.paused = true
		attacker.get_node("attack").play()
		await get_tree().create_timer(0.5).timeout
		$turntime.paused = false
		$Effect.visible = false
		if target.hpObstacle == 0 :
			var tempClearSolid = obstacle_manager.obstacles.find_key(target)
			astar_grid.set_point_solid(tempClearSolid,false)
			obstacle_manager.obstacles.erase(tempClearSolid)
			attacker.health = target.prizeHealth
			attacker.energy = target.prizeEnergy
			attacker.get_new_value_attribute()
	actionoption.visible = false
	_is_action_selected = false
	_helpper_is_play = false
	_helper_selected_action = ""

# Todo filter input : can input only in battle state
func _input(event):
	#ketika script berjalan didalam game
	if not Engine.is_editor_hint():
		#	#jika input(event) adalah sebuah tombol mouse
		if event is InputEventMouseButton:
			if event.is_action_pressed("left-click"):
				if battle_manager.get_battle_state() == 4:
					if !_helper_hover and !_helpper_is_play:
						lets_select_unit()
				elif battle_manager.get_battle_state() == 3:
					get_parent().get_node("Deploy_sound").play()
					create_robot(gridder)
				#tambahan kondisi tombol diatas
		if event is InputEventMouseMotion:
			if astar_grid.is_in_boundsv(local_to_map(event.position-position)):
				if battle_manager.get_battle_state() == 3:
					if robot_count < 3:
						gridder.x = min(max(local_to_map(event.position-position).x, redTeam_deploy_zone.min().x), redTeam_deploy_zone.max().x)
						gridder.y = min(max(local_to_map(event.position-position).y, redTeam_deploy_zone.min().y), redTeam_deploy_zone.max().y)
						prerender()
						$Pergerakan.posisikan_indikator(map_to_local(gridder))
					else:
						gridder.x = min(max(local_to_map(event.position-position).x, blueTeam_deploy_zone.min().x), blueTeam_deploy_zone.max().x)
						gridder.y = min(max(local_to_map(event.position-position).y, blueTeam_deploy_zone.min().y), blueTeam_deploy_zone.max().y)
						prerender()
						$Pergerakan.posisikan_indikator(map_to_local(gridder))
				else:
					gridder = local_to_map(event.position-position)
					if _helper_selected_action == "move" and _is_action_selected:
						if highlight_zone.has(gridder):
							prerender()
							$Pergerakan.posisikan_indikator(map_to_local(gridder))
					if ( 
						(_helper_selected_action == "attack" and _is_action_selected ) or 
						(_helper_selected_action == "skill" and _is_action_selected )
					):
						if highlight_zone.has(gridder):
							$Pergerakan.posisikan_indikator(map_to_local(gridder))
					else :
						$Pergerakan.posisikan_indikator(map_to_local(gridder))
					
					#Fixme : robot info only on battle
					#robot information
					if robots_manager.robots["redTeam"]["object"].has(gridder):
						var _temp_robot_info = robots_manager.robots["redTeam"]["object"][gridder].get_robot_datas()
						robot_information.set_info(_temp_robot_info)
						if get_parent().get_node("Container").visible == false :
							get_parent().get_node("Container").visible = true
					elif robots_manager.robots["blueTeam"]["object"].has(gridder) :
						var _temp_robot_info = robots_manager.robots["blueTeam"]["object"][gridder].get_robot_datas()
						robot_information.set_info(_temp_robot_info)
						if get_parent().get_node("Container").visible == false :
							get_parent().get_node("Container").visible = true
					else :
						if get_parent().get_node("Container").visible == true :
							get_parent().get_node("Container").visible = false
			else :
				if _helper_hover and _is_action_selected:
					gridder = local_to_map(event.position-position)
					if _helper_selected_action == "move" and _is_action_selected:
						if highlight_zone.has(gridder):
							prerender()
							$Pergerakan.posisikan_indikator(map_to_local(gridder)) # fix may be causing error in next progress
	#jika input(event) adalah sebuah tombol keyboard
		if event is InputEventKey:
	#kalkulasi arah gridder berdasarkan input
			if event.is_action_pressed("ui_up"):
					gridder += Vector2i.UP
			elif event.is_action_pressed("ui_right"):
					gridder += Vector2i.RIGHT
			elif event.is_action_pressed("ui_left"):
					gridder += Vector2i.LEFT
			elif event.is_action_pressed("ui_down"):
					gridder += Vector2i.DOWN
	#
	#pencegahan agar indikator tidak keluar arena
			if astar_grid.is_in_boundsv(gridder):
				$Pergerakan.posisikan_indikator(map_to_local(gridder))
			else:
				gridder = local_to_map($Pergerakan.get_posisi_indikator())
	#
	#input ketika indikator memilih robot
			if event.is_action_pressed("ui_home"):
				if !_helper_hover and !_helpper_is_play:
					lets_select_unit()
				#highlight()
	#
	
	#refresh ulang tampilan
			#prerender()
	#
func lets_select_unit():
	if robots_manager.robots[team]["object"].has(gridder) and !_is_action_selected and robots_manager.robots[team]["object"][gridder].robotState != 9:
		#print(robots_manager.robots[team]["object"][gridder].get_robot_datas()) penting!!!
		actionoption.position = map_to_local(gridder)+Vector2(32,0)
		highlight_zone.clear()
		$Highlight.clear()
		_is_action_selected = false
		actionoption.visible = true
		$Pergerakan.target_yang_dipindahkan = robots_manager.robots[team]["object"][gridder]
		_temp_action_point = robots_manager.mechAction[robots_manager.robots[team]["object"][gridder]]
		action_option_move.visible = true if (
			_temp_action_point[0] == 1 and
			robots_manager.robots[team]["object"][gridder].energy >= robots_manager.robots[team]["object"][gridder].moveEnergy
		) else false
		action_option_attack.visible = true if (
			_temp_action_point[1] == 1 and
			robots_manager.robots[team]["object"][gridder].energy >= robots_manager.robots[team]["object"][gridder].attackEnergy
		) else false
		action_option_skill.visible = true if (
			_temp_action_point[2] == 1 and
			robots_manager.robots[team]["object"][gridder].energy >= robots_manager.robots[team]["object"][gridder].skillEnergy
		) else false
		if $Pergerakan.target_yang_dipindahkan != null:
				start = gridder
	else :
		if !_is_action_selected : # akan tereksekusi saat memilih set saat menu terlihat 
			actionoption.visible = false
		if _is_action_selected and _helper_selected_action == "move" and gridder != start:
			_helpper_is_play = true
			var _helper_is_robot_in_target_loc = (
				robots_manager.robots["blueTeam"]["object"].has(gridder) or
				robots_manager.robots["redTeam"]["object"].has(gridder) or 
				obstacle_manager.obstacles.has(gridder)
			)
			if !_helper_is_robot_in_target_loc and highlight_zone.has(gridder):
				highlight_zone.clear()
				$Highlight.clear()
				_helper_multiple = packedpoints.size() - 1
				robots_manager.robots[team]["object"][start].consume_energy(robots_manager.robots[team]["object"][start].moveEnergy,_helper_multiple)
				move_unit()
				_helper_multiple = 1
			elif _helper_is_robot_in_target_loc:
				_is_action_selected = false
				_helper_selected_action = ""
				_helpper_is_play = false
				highlight_zone.clear()
				$Highlight.clear()
				$Pergerakan.curve.clear_points()
				$Pergerakan.get_node("Pathline").clear_points()
			elif !highlight_zone.has(gridder):
				_is_action_selected = false
				_helper_selected_action = ""
				_helpper_is_play = false
				highlight_zone.clear()
				$Highlight.clear()
				$Pergerakan.curve.clear_points()
				$Pergerakan.get_node("Pathline").clear_points()
				
		elif _is_action_selected and (_helper_selected_action == "attack" or _helper_selected_action == "skill"):
			_helpper_is_play = true
			if team == "redTeam" and gridder != start:
				if highlight_zone.has(gridder):
					if robots_manager.robots["blueTeam"]["object"].has(gridder) :
						_attack_target(_helper_selected_action,robots_manager.robots[team]["object"][start],robots_manager.robots["blueTeam"]["object"][gridder])
					elif obstacle_manager.obstacles.has(gridder):
						_attack_target(_helper_selected_action,robots_manager.robots[team]["object"][start],obstacle_manager.obstacles[gridder])
					else:
						_is_action_selected = false
						_helper_selected_action = ""
						_helpper_is_play = false
				else :
					_is_action_selected = false
					_helper_selected_action = ""
					_helpper_is_play = false
			elif team == "blueTeam" and gridder != start:
				if highlight_zone.has(gridder):
					if robots_manager.robots["redTeam"]["object"].has(gridder) :
						_attack_target(_helper_selected_action,robots_manager.robots[team]["object"][start],robots_manager.robots["redTeam"]["object"][gridder])
					elif obstacle_manager.obstacles.has(gridder):
						_attack_target(_helper_selected_action,robots_manager.robots[team]["object"][start],obstacle_manager.obstacles[gridder])
					else:
						_is_action_selected = false
						_helper_selected_action = ""
						_helpper_is_play = false
				else :
					_is_action_selected = false
					_helper_selected_action = ""
					_helpper_is_play = false
			else :
				_is_action_selected = false
				_helper_selected_action = ""
				_helpper_is_play = false
				highlight_zone.clear()
				$Highlight.clear()
			highlight_zone.clear()
			$Highlight.clear()
		else :
			_is_action_selected = false
			_helper_selected_action = ""
			_helpper_is_play = false
			highlight_zone.clear()
			$Highlight.clear()
		recount()
	if _is_action_selected:
		_helper_selected_action = ""




func recount():
	var redHPnow = 0
	var redEPnow = 0
	var blueHPnow = 0
	var blueEPnow = 0
	for red in redies:
		redHPnow += red.health
		redEPnow += red.energy
	for blue in blues:
		blueHPnow += blue.health
		blueEPnow += blue.energy
	$button_end_turn/Blue/HBoxContainer/VBoxContainer/Hp/ProgressBar.value = blueHPnow*100/blueHP
	$button_end_turn/Blue/HBoxContainer/VBoxContainer/Ep/ProgressBar.value = blueEPnow*100/blueEP
	$button_end_turn/Red/HBoxContainer/VBoxContainer/Hp/ProgressBar.value = redHPnow*100/redHP
	$button_end_turn/Red/HBoxContainer/VBoxContainer/Ep/ProgressBar.value = redEPnow*100/redEP

func move_unit():
	if packedpoints.size() > 1: #cek apakah pergerakan lebih dari 1
		$Pergerakan.initpath() #robot akan bergerak
		_helpper_is_play = true
		robots_manager.robots[team]["object"].erase(start) #robot akan dihapus dari array  
		astar_grid.set_point_solid(start,false)
			#popup action option =====================
		actionoption.visible = false
		_is_action_selected = false
		actionoption.visible = false

#alur =
#-jika lebih dari 1 akan menggambar
func prerender():
		
		if _is_action_selected:
			if astar_grid.is_in_boundsv(gridder):
				packedpoints = astar_grid.get_point_path(start, gridder)
				$Pergerakan.repath(packedpoints)
				

#ketika selesai bergerak ->
func _on_pergerakan_move_finished(last_robot : Node2D):
	robots_manager.robots[team]["object"][local_to_map(last_robot.position)] = last_robot #lokasi terakhir robot akan ditambahkan ke array
	robots_manager.robots[team]["data"][local_to_map(last_robot.position)] = last_robot.get_robot_datas() #lokasi terakhir robot akan ditambahkan ke array
	astar_grid.set_point_solid(local_to_map(last_robot.position))
	if _helper_selected_action == "move" :
		_temp_action_point[0] = 0
		managed_action.emit(last_robot,_temp_action_point)
	_helpper_is_play = false # bisa coba ganti sendiri , cuma mencegah select ketika sedang execut robot
	_helper_selected_action = ""
	

func _on_actionoption_selected_action(value):
	if value == "move" :
		_helper_selected_action = "move"
	elif value == "attack" :
		_helper_selected_action = "attack"
	elif value == "skill" :
		_helper_selected_action = "skill"
		
	if actionoption.is_visible_in_tree():
		_is_action_selected = true
		actionoption.visible = false
		if _helper_selected_action == "move" :
			if robots_manager.robots[team]["object"][start].energy <= robots_manager.robots[team]["object"][start].moveRange :
				highlight(
					local_to_map($Pergerakan.target_yang_dipindahkan.position),
				 	_helper_selected_action,
					robots_manager.robots[team]["object"][start].energy
				)
			else :
				highlight(
					local_to_map($Pergerakan.target_yang_dipindahkan.position),
				 	_helper_selected_action,
					robots_manager.robots[team]["object"][start].moveRange
				)
		elif _helper_selected_action == "attack" :
			
			highlight(
				local_to_map($Pergerakan.target_yang_dipindahkan.position),
				 _helper_selected_action,
				robots_manager.robots[team]["data"][start]["attackRange"]
			)
		elif _helper_selected_action == "skill" :
			
			highlight(
				local_to_map($Pergerakan.target_yang_dipindahkan.position),
				 _helper_selected_action,
				robots_manager.robots[team]["data"][start]["skillRange"]
			)

func _on_actionoption_mouse_entered_each_option(condition):
	_helper_hover = condition

# Fixme : Deployzone diatur disini
# todo : nyampur sama first rounds
func _on_obstacle_timer_timeout():
	battle_manager.set_battle_state(battle_manager.BattleState.DEPLOYING)
	for x in tile_set.mapSize.x:
		for y in tile_set.mapSize.y:
			if y < 4:
				redTeam_deploy_zone = redTeam_deploy_zone + [Vector2i(x,y)]
			elif y > 5:
				blueTeam_deploy_zone = blueTeam_deploy_zone + [Vector2i(x,y)]
	
	$Deployzone.position = Vector2i(map_to_local(redTeam_deploy_zone.min())) - (tile_set.cellSize/2)
	$Deployzone.size = Vector2i(map_to_local(redTeam_deploy_zone.max() - redTeam_deploy_zone.min())) + (tile_set.cellSize/2)
	$Deployzone.modulate = Color.RED
	$Deployzone.visible = true
	#DEPLOYYYY
	#create_robot()
	#DEPLOYYYY
	#$turntime.start()

# todo add battleState == 1 here !!
func _on_battle_manager_changed_state():
	if visible == false :
		visible = true
		$Deployzone.visible = false
		$enterarena.start()
		#+++ animasi masuk game


func _on_enterarena_timeout():
	battle_manager.set_battle_state(battle_manager.BattleState.OBSTACLECREATE)
	if (Global.maptype == 2 or Global.maptype == 1) and !_helper_create_once_obstacle:
		print("dengan obstacle")
		_helper_create_once_obstacle = true
		create_obstacles_multiplayer()
	elif Global.maptype == 0 :
		print("tanpa obstacle")
		_on_obstacle_timer_timeout()


func _on_battle_manager_battleended(value):
	battle_manager.set_battle_state(battle_manager.BattleState.BATTLEEND)
	$turntime.stop()


func _on_battle_manager_switched():
	$Pergerakan.curve.clear_points()
	$Pergerakan.get_node("Pathline").clear_points()
	highlight_zone.clear()
	$Highlight.clear()
	_is_action_selected = false
	_helper_selected_action = ""
	_helpper_is_play = false
	if _helper_endturn:
		_helper_endturn = false
	if team == "redTeam" and battle_manager.get_battle_state() == 4:
		team = "blueTeam"
		battle_manager.calculate_turn_point("redTeam")
		#if $Pergerakan.target_yang_dipindahkan != null :
			#$Pergerakan.target_yang_dipindahkan = null
		if actionoption.is_visible_in_tree():
			actionoption.visible = false
	elif team == "blueTeam" and battle_manager.get_battle_state() == 4:
		team = "redTeam"
		battle_manager.calculate_turn_point("blueTeam")
		#if $Pergerakan.target_yang_dipindahkan != null :
			#$Pergerakan.target_yang_dipindahkan = null
		if actionoption.is_visible_in_tree():
			actionoption.visible = false
	if team == "redTeam":
		for child in robots_manager.robots["redTeam"]["object"]:
			if robots_manager.mechAction[robots_manager.robots["redTeam"]["object"][child]] == [1,1,1] and robots_manager.robots["redTeam"]["object"][child].robotState != 9:
				robots_manager.robots["redTeam"]["object"][child].set_robot_state(robots_manager.robots["redTeam"]["object"][child].RobotState.IDLE)
			robots_manager.robots["redTeam"]["object"][child].restore_energy()
			robots_manager.mechAction[robots_manager.robots["redTeam"]["object"][child]] = [1,1,1]
	if team == "blueTeam" :
		for child in robots_manager.robots["blueTeam"]["object"]:
			if robots_manager.mechAction[robots_manager.robots["blueTeam"]["object"][child]] == [1,1,1] and robots_manager.robots["blueTeam"]["object"][child].robotState != 9:
				robots_manager.robots["blueTeam"]["object"][child].set_robot_state(robots_manager.robots["blueTeam"]["object"][child].RobotState.IDLE)
			robots_manager.robots["blueTeam"]["object"][child].restore_energy()
			robots_manager.mechAction[robots_manager.robots["blueTeam"]["object"][child]] = [1,1,1]
	redpoint.text = str(battle_manager.turnPoint[0])
	bluepoint.text = str(battle_manager.turnPoint[1])
	turned.emit(team)
	if battle_manager.turnPoint[0] == 0 and battle_manager.turnPoint[1] == 0 :
		ended.emit()

# FIXME : Deleted battle_manager.get_battle_state() == 3
func _on_button_end_turn_button_down():
	if battle_manager.get_battle_state() == 4 :
		_helper_endturn = true
		$turntime.stop()
		$turntime.timeout.emit()
		$turntime.start()
		
func _on_robot_death(value):
	$button_end_turn.recount()



func _on_robot_destroy(value):
	astar_grid.set_point_solid(local_to_map(value.position),false)
	if team == "redTeam":
		var key = local_to_map(value.position)
		robots_manager.robots["blueTeam"]["object"].erase(key)
	elif team == "blueTeam":
		var key = local_to_map(value.position)
		robots_manager.robots["redTeam"]["object"].erase(key)


func _on_go_to_menu_button_down():
	Global.clear_battle()
	if visible == true :
		visible = false
