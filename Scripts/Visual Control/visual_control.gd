extends Node
class_name VisualControl


@export var main_menu_scene: PackedScene
@export var arena_tilemap_scene: PackedScene
@export var base_tilemap_scene: PackedScene
@export var battle_environtment_scene: PackedScene
@export var game_object_scene: PackedScene
@export var selector_scene: PackedScene
var main_menu: MainMenu
var arena_tilemap: TileGrid
var base_tilemap: TileGrid
var battle_environtment: BattleEnvirontment
var game_object: GameObject
var selector: Selector

func prepare():
	main_menu= main_menu_scene.instantiate()
	arena_tilemap= arena_tilemap_scene.instantiate()
	base_tilemap= base_tilemap_scene.instantiate()
	battle_environtment= battle_environtment_scene.instantiate()
	game_object= game_object_scene.instantiate()
	selector= selector_scene.instantiate()
	
	add_child(battle_environtment)
	add_child(base_tilemap)
	add_child(arena_tilemap)
	add_child(game_object)
	add_child(selector)
	add_child(main_menu)
	
	main_menu.show()
	arena_tilemap.hide()
	base_tilemap.hide()
	battle_environtment.hide()
