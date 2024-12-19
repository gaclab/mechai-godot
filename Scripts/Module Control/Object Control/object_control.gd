extends Node
class_name ObjectControl

@export var robot_template_scene: PackedScene
var robot_template: Robot
var selected_robot: Robot

func prepare():
	robot_template= robot_template_scene.instantiate()

func new_robot_group(group_name: String, robot_count: int) -> Node:
	var group_root= Node.new()
	group_root.name= group_name
	for i in robot_count:
		var robot: Robot= robot_template.duplicate()
		group_root.add_child(robot)
	return group_root

func drag_selected():
	if is_instance_valid(selected_robot):
		selected_robot.position= Control_Core.visual_control.selector.event_position

func select_robot(robot: Robot):
	if !is_instance_valid(robot):
		if is_instance_valid(selected_robot):
			var selector= Control_Core.visual_control.selector
			var gridded_pos= selector.tilegrid_owner.align_position(selected_robot.position)
			Control_Core.visual_control.game_object.change_robot_owner(selected_robot, selector.tilegrid_owner)
			Control_Core.visual_control.game_object.change_robot_pos(selected_robot, gridded_pos)
	selected_robot= robot

func select_robot_action(robot: Robot):
	if is_instance_valid(robot):
		if is_instance_valid(selected_robot):
			if selected_robot != robot:
				selected_robot.send_attack(robot)
		elif !is_instance_valid(selected_robot):
			selected_robot= robot
	elif !is_instance_valid(robot):
		selected_robot= robot
	print(selected_robot)
		
