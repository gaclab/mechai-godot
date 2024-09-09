@tool
extends Resource
class_name Obstacle_Summon
@export var _max_obstacle : int = 30
@export var _min_obstacle : int = 8
var _multiplayer_location : PackedVector2Array 

func _getMultiplayerLocation(tilegrid : TileMap):
	_multiplayer_location = []
	var total_obstacle = randi_range(_min_obstacle,_max_obstacle)
	var zona_arena : Array[Vector2i] = tilegrid.get_used_cells(0)
	var temp = []
	
	var count = 0
	while count <= total_obstacle:
		var random_index = randi_range(0,zona_arena.size()-1)
		if !temp.has(random_index):
			temp.append(random_index)
			_multiplayer_location.append(zona_arena[random_index])
			count+=1
	return _multiplayer_location
