@tool
extends Resource
class_name Obstacle_Summon
var grid = load("res://Assets/Tres/Grid.tres")
@export var _max_obstacle : int = 30
@export var _min_obstacle : int = 8
var _total_obstacle : int 
var _multiplayer_location : PackedVector2Array 
var list_cell : PackedVector2Array 

func _getMultiplayerLocation()->PackedVector2Array:
	_total_obstacle = randi_range(_min_obstacle,_max_obstacle)
	var temp = []
	for j in grid._mapSize.x :
		for h in grid._mapSize.y :
			list_cell.append(Vector2i(j,h))
	print(list_cell)
	for i in _total_obstacle:
		var random_index = randi_range(0,99)
		if(!temp.has(random_index)):
			temp.append(random_index)
			_multiplayer_location.append(list_cell[random_index])
			print(random_index)
	list_cell.clear()
	return _multiplayer_location
	
	
