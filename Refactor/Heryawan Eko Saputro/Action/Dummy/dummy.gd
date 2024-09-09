extends TileMapLayer
class_name dummy

#map
var gridder = Vector2i(2,2)
func get_route(radius: int, start_pos: Vector2i, end_pos: Vector2i):
	var route = [Vector2(12, 34), Vector2(56, 78)]
	return route
#robot_manager
func get_robot_in_gridder(gridder: Vector2i):
	var selected_robot = 232345
	return selected_robot
