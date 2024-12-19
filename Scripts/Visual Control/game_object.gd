extends Node
class_name GameObject

var object_groups= {
	
}

var object_tilegrid= {
	
}

var object_pos= {
	
}

func add_group(group: Node, tilegrid_owner: TileGrid):
	var member= group.get_children()
	for i: Robot in member:
		object_groups[i]= group
		object_tilegrid[i]= tilegrid_owner
		var clipped_pos= tilegrid_owner.local_to_map(i.position)
		object_pos[clipped_pos]= i
	add_child(group)

func robot_by_position(global_gridded_pos: Vector2, tilegrid_owner: TileGrid):
	var localized_pos= tilegrid_owner.local_to_map(global_gridded_pos)
	if object_pos.has(localized_pos):
		var robot= object_pos[localized_pos]
		if object_tilegrid[robot] == tilegrid_owner:
			return object_pos[localized_pos]
	return null

func owner_of_robot(robot: Robot):
	if object_tilegrid.has(robot):
		return object_tilegrid[robot]
	return null

func change_robot_owner(robot: Robot, tilegrid_owner: TileGrid):
	if object_tilegrid.has(robot):
		object_tilegrid[robot]= tilegrid_owner

func change_robot_pos(robot: Robot, global_gridded_pos: Vector2):
	robot.position= global_gridded_pos
	for K in object_pos:
		if object_pos[K] == robot:
			object_pos.erase(K)
	var robot_owner: TileGrid= owner_of_robot(robot)
	var localized_robot_pos= robot_owner.local_to_map(global_gridded_pos)
	object_pos[localized_robot_pos]= robot
