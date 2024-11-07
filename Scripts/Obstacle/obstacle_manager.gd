extends Node
class_name ObstacleManager

signal stated 
signal instatied(instance: Node)

@onready var myObstacle = preload("res://Scenes/Obstacle/obstacles.tscn").instantiate()
#var MultiplayerObstacle : Resource = preload("res://Assets/Tres/MultiPlayerObstacle.tres") 
var _max_obstacle : int = 30
var _min_obstacle : int = 8
var total_obstacle : int
var obstacleLocation : PackedVector2Array
var zona_arena : Array[Vector2i] = []
var is_stand : bool = true
#var Gridsize : int = 10

func _init(typeof_obstacle:Battle.OBSTACLE_TYPE) -> void:
	pass
#@onready var obstacles : Dictionary = {}
func _ready():
	#var obstacle_node = get_node("Obstacle")
	#myObstacle.health_updated.connect(on_health_updated)
	pass

func deploy_obstacle(battle_obstacle:Battle.OBSTACLE_TYPE):
	#deploying obstacle state
	if battle_obstacle == Battle.OBSTACLE_TYPE.RANDOM:
		for i in random_deploy(Global.battle.map.tile_map):
			var stack :Obstacle = myObstacle.duplicate()
			add_child(stack)
			stack.position = Global.battle.map.set_in_map(i)
			Global.battle._update_tile_data(Vector2i(0,0),i,stack)
			stack.pos_in_map = i
			await get_tree().create_timer(0.01).timeout
			stack.playanimatedspawn()
	elif battle_obstacle == Battle.OBSTACLE_TYPE.PREDEFINED:
		for i in Global.premaps[Global.selected_premap]:
			var stack :Obstacle = myObstacle.duplicate()
			add_child(stack)
			stack.position = Global.battle.map.set_in_map(i)
			Global.battle._update_tile_data(Vector2i(0,0),i,stack)
			stack.pos_in_map = i
			await get_tree().create_timer(0.01).timeout
			stack.playanimatedspawn()
		pass

func random_deploy(spawn : TileMapLayer) -> PackedVector2Array:
	var spawn_location : Vector2
	obstacleLocation.clear()
	total_obstacle = randi_range(_min_obstacle,_max_obstacle)
	zona_arena = spawn.get_used_cells()
	
	var temp : Array[int] = [] 
	var count : int = 0
	while count < total_obstacle:
		var random_index : int = randi_range(0,zona_arena.size()-1)	
		if not temp.has(random_index):
			temp.append(random_index)
			obstacleLocation.append(zona_arena[random_index])
			count+=1
	
	#for location in obstacleLocation:	
		#var instance : Obstacle = myObstacle.instantiate()
		#var sb = instance.get_node("solidbar")
		#if not sb == null:
			#sb.visible = false	
		#instatied.emit(instance)
	#
		##myObstacle.health_updated.connect(on_health_updated)
		#spawn_location = location
	
	return obstacleLocation
	
	
func on_health_updated(hpObstacle):
	if hpObstacle == 0:
		is_stand = false
	stated.emit(self)

#var preobs = []
#func dev_obstacle_editor(robotpos : Vector2i):
	#if !astar_grid.is_point_solid(robotpos): #memposisikan setiap obstacle
		#var unit = myObstacle.duplicate()
		#var sb = unit.get_node("solidbar")
		#sb.visible = false
		#unit.position = map_to_local(robotpos) #memposisikan setiap obstacle
		#add_child(unit) #menambahkan setiap obstacle kedalam tree
		#preobs = preobs + [robotpos]
		#unit.playanimatedspawn()
		#astar_grid.set_point_solid(robotpos)
		#await get_tree().create_timer(0.1).timeout
		
#func create_obstacles_multiplayer():
	##bagian generate obstacle
		##generate obstacle in multiplayer
		#var obstacleLocation = PackedVector2Array()
		#if Global.maptype == 2:
			#obstacleLocation = Multiplayer._getMultiplayerLocation(self) #ambil posisi seluruh obstacle
		#elif Global.maptype == 1:
			#obstacleLocation = Global.premaps[Global.selected_premap]
		#Obstacle.get_node("solidbar").visible = false
		#for i in obstacleLocation:
			#var stack : Obstacles = Obstacle.duplicate() #duplikasi objek obstacle
			#var sb = stack.get_node("solidbar")
			#sb.visible = false
			#stack.position = map_to_local(i) #memposisikan setiap obstacle
			#add_child(stack) #menambahkan setiap obstacle kedalam tree
			#obstacle_manager.obstacles[Vector2i(i)] = stack
			#stack.playanimatedspawn()
			#astar_grid.set_point_solid(i,true)
			#await get_tree().create_timer(0.1).timeout
		#_on_obstacle_timer_timeout()
		
		
