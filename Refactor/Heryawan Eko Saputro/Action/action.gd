extends Node2D
class_name Action
var test_dummy = dummy.new()

var action_layer: Dictionary = {}
var current_object: Object = null
var tween : Tween

func move_robot(robot_id: int, target: PackedVector2Array):
	if !action_layer.has(robot_id):
		action_layer[robot_id] = {"action": "move", "target": target}
		tween_on()

func tween_on():
	if !is_instance_valid(tween):
		for pathpoint in action_layer[action_layer.keys()[0]]["target"]:
			$Path2D.curve.add_point(test_dummy.map_to_local(pathpoint))
		current_object = instance_from_id(action_layer.keys()[0])
		tween = create_tween()
		tween.tween_property($Path2D/PathFollow2D,"progress_ratio",1,1)
		tween.connect("finished", layer_done)
		tween.play()
	elif !tween.is_running():
		for pathpoint in action_layer[action_layer.keys()[0]]["target"]:
			$Path2D.curve.add_point(test_dummy.map_to_local(pathpoint))
		current_object = instance_from_id(action_layer.keys()[0])
		tween = create_tween()
		tween.tween_property($Path2D/PathFollow2D,"progress_ratio",1,1)
		tween.connect("finished", layer_done)
		tween.play()

func _process(delta: float) -> void:
	if is_instance_valid(current_object):
		current_object.position = $Path2D/PathFollow2D.position

func layer_done():
	action_layer.erase(action_layer.keys()[0])
	$Path2D/PathFollow2D.progress_ratio = 0
	$Path2D.curve.clear_points()
	current_object = null
	if !action_layer.is_empty():
		for pathpoint in action_layer[action_layer.keys()[0]]["target"]:
			$Path2D.curve.add_point(test_dummy.map_to_local(pathpoint))
		current_object = instance_from_id(action_layer.keys()[0])
		tween = create_tween()
		tween.tween_property($Path2D/PathFollow2D,"progress_ratio",1,1)
		tween.connect("finished", layer_done)
		tween.play()
