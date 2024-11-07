extends Node2D
class_name Map

var tile_map : TileMapLayer
var environment = preload("res://Scenes/Map/env_map.tscn").instantiate()
var astar : AstarGrid
var path : Pathforall
var pra_deploy
var red_deploy_zone :Array = []
var blue_deploy_zone :Array = []

func _create_deploy_zone():
	for x in tile_map.grid_size.x:
		for y in tile_map.grid_size.y:
			if y < 4:
				red_deploy_zone = red_deploy_zone + [Vector2i(x,y)]
			elif y > 5:
				blue_deploy_zone = blue_deploy_zone + [Vector2i(x,y)]
	red_deploy_zone = red_deploy_zone + [Vector2i(13,-1),Vector2i(12,-1),Vector2i(11,-1)]
	blue_deploy_zone = blue_deploy_zone + [Vector2i(-4,10),Vector2i(-3,10),Vector2i(-2,10)]
func _is_inside_zone(turn:Battle.TURN_STATE,pos):
	if turn == Battle.TURN_STATE.RED:
		if red_deploy_zone.has(pos):
			return true
		else :
			return false
	elif turn == Battle.TURN_STATE.BLUE:
		if blue_deploy_zone.has(pos):
			return true
		else :
			return false
	

func _init(map_size:Vector2i,map_environmnet:Battle.ENVIRONMENT_TYPE) -> void:
	tile_map = TileMaps.new(map_size)
	tile_map.name = 'TileMap'
	tile_map.z_index = 1
	add_child(tile_map)
	#environment = BattleEnvirontment.new(map_environmnet)
	environment.name = 'BattleEnvironment'
	add_child(environment)
	astar = AstarGrid.new(tile_map,AStarGrid2D.DIAGONAL_MODE_NEVER,
			AStarGrid2D.HEURISTIC_MANHATTAN,
			AStarGrid2D.HEURISTIC_MANHATTAN)
	path = preload("res://Scenes/Paths/path.tscn").instantiate()
	add_child(path)
	pra_deploy = preload("res://Scenes/Map/pra_deploy.tscn").instantiate()
	add_child(pra_deploy)
	
	
	
func _ready() -> void:
	_create_map()
	#pra_deploy.position += Vector2(320,320)
	get_window().size_changed.connect(Callable(self,'_create_map'))
	_create_deploy_zone()
	
func _create_map():
	if tile_map != null :
		var media = get_viewport_rect().size
		var new_mapSize = tile_map.tile_set.tile_size*tile_map.grid_size
		position = (Vector2i(media)-new_mapSize)/2


func get_object_loc(object)->Vector2i:
	#print(object.position)
	return tile_map.local_to_map(object.position)
	
func set_in_map(coord:Vector2i):
	var media = get_viewport_rect().size
	var new_mapSize = tile_map.tile_set.tile_size*tile_map.grid_size
	return tile_map.map_to_local(coord)+Vector2(media-Vector2(new_mapSize))/2

func update_loc(object,coord:Vector2i):
	pass
	astar.set_Solid(coord)
#func deploy_object(object,tile:Vector2i)->void:
	#if _tile_data[tile] == null:
		#_tile_data[tile] = object
		#astar.set_Solid(tile)
		#object.position = tile_map.map_to_local(tile)

#func move_object(object,tile:Vector2i)->void:
	#var _old_loc = get_object_loc(object)
	#var astarpath = astar.get_astarPath(_old_loc,tile)
	#astar.set_Unsolid(_old_loc)
	#_tile_data[_old_loc] = null
	#_tile_data[tile] = object
	#_path.repath(astarpath)
	#_path.initPath(object,500.0)
	#astar.set_Solid(tile)
	#object.position = tile_map.map_to_local(tile)
#func remove_object(tile:Vector2i):
	#_tile_data[tile] = null
