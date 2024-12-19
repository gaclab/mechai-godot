extends Node2D
class_name ControlCore

var visual_control: VisualControl
var module_control: ModuleControl
var game_control: GameControl
var time_control: TimeControl

func get_media_size():
	return get_viewport_rect().size
