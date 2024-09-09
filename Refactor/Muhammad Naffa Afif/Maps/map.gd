extends Node2D
class_name Map

var astar:AstarGrid
var _tile_data:Dictionary
@onready var tile_map : TileMapLayer = $tileMap 
@onready var _path : Pathforall = $path

func _ready() -> void:
	_create_map()
	astar = AstarGrid.new()
	astar.AstarGrid(tile_map.tile_set)
	astar.set_Solid(Vector2i(4,2))
	astar.set_Solid(Vector2i(5,3))
	astar.set_Solid(Vector2i(6,4))
	deploy_object($Robottest,Vector2i(0,0))
	await get_tree().create_timer(2.0).timeout
	move_object($Robottest,Vector2i(9,9))

	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _create_map():
	if tile_map != null :
		var media = get_viewport().size
		var new_mapSize = tile_map.tile_set.tile_size*tile_map.tile_set.grid_size
		position = (media-new_mapSize)/2
		#var grid_count = tile_set.grid_size.x*tile_set.grid_size.y
		
		for x in tile_map.get_used_cells():
			_tile_data.merge({x:null})

func get_object_loc(object:Robot)->Vector2i:
	return tile_map.local_to_map(object.position)

func deploy_object(object,tile:Vector2i)->void:
	if _tile_data[tile] == null:
		_tile_data[tile] = object
		astar.set_Solid(tile)
		object.position = tile_map.map_to_local(tile)

func move_object(object:Robot,tile:Vector2i)->void:
	var _old_loc = get_object_loc(object)
	var astarpath = astar.get_astarPath(_old_loc,tile)
	astar.set_Unsolid(_old_loc)
	_tile_data[_old_loc] = null
	_tile_data[tile] = object
	_path.repath(astarpath)
	_path.initPath(object,500.0)
	astar.set_Solid(tile)
	#object.position = tile_map.map_to_local(tile)
func remove_object(tile:Vector2i):
	_tile_data[tile] = null
