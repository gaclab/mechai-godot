extends Node
class_name AstarGrid

var _astar_grid : AStarGrid2D
#Construct astar_grid
func AstarGrid(tile_set:TileSet):
	_astar_grid = AStarGrid2D.new()
	_astar_grid.size = tile_set.grid_size # setting ukuran peta
	_astar_grid.cell_size = tile_set.tile_size # setting ukuran kolom
	_astar_grid.offset = tile_set.tile_size/2 # setting offset astar_grid
	#setting algoritma astar_grid
	_astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar_grid.update() #update astar_grid

func set_Solid(solid_location:Vector2i): #set location to solid
	_astar_grid.set_point_solid(solid_location,true)

func set_Unsolid(solid_location:Vector2i): #set location to unsolid/unpassable
	_astar_grid.set_point_solid(solid_location,false)

func get_astarPath(start:Vector2i,end:Vector2i)->PackedVector2Array: # get the path with start value and end value base on manhattan Algoritm
	return _astar_grid.get_point_path(start,end)

func is_locationSolid(solid_location:Vector2i)->bool: # check location solid
	return _astar_grid.is_point_solid(solid_location)
func is_insideMap(location:Vector2i)->bool: # check input location is inside off map
	return _astar_grid.is_in_boundsv(location)
