extends AStarGrid2D
class_name AstarGrid
#Construct astar_grid
func _init(
	tile_map:TileMaps,diagonal_mode:AStarGrid2D.DiagonalMode,
	compute_heuristic:AStarGrid2D.Heuristic,
	estimate_heuristic:AStarGrid2D.Heuristic) -> void:
	self.size = tile_map.grid_size
	self.cell_size = tile_map.tile_set.tile_size
	self.offset = tile_map.tile_set.tile_size/2
	self.diagonal_mode = diagonal_mode
	self.default_compute_heuristic = compute_heuristic
	self.default_estimate_heuristic = estimate_heuristic
	update()

func set_Solid(solid_location:Vector2i): #set location to solid
	set_point_solid(solid_location,true)

func set_Unsolid(solid_location:Vector2i): #set location to unsolid/unpassable
	set_point_solid(solid_location,false)

func get_astarPath(start:Vector2i,end:Vector2i)->PackedVector2Array: # get the path with start value and end value base on manhattan Algoritm
	return get_point_path(start,end)

func is_locationSolid(solid_location:Vector2i)->bool: # check location solid
	return is_point_solid(solid_location)
func is_insideMap(location:Vector2i)->bool: # check input location is inside off map
	return is_in_boundsv(location)
