extends Node
class_name ModuleControl

@export var arena_builder_scene: PackedScene
@export var highlight_builder_scene: PackedScene
@export var object_control_scene: PackedScene
@export var team_manager_scene: PackedScene

var arena_builder: ArenaBuilder
var highlight_builder: HighlightBuilder
var object_control: ObjectControl
var team_manager: TeamManager

func prepare():
	arena_builder= arena_builder_scene.instantiate()
	highlight_builder= highlight_builder_scene.instantiate()
	object_control= object_control_scene.instantiate()
	team_manager= team_manager_scene.instantiate()
	
	add_child(arena_builder)
	add_child(highlight_builder)
	add_child(object_control)
	add_child(team_manager)
	
	object_control.prepare()
