extends Node
class_name TeamManager

@export var teamA_size= 3
@export var teamB_size= 3
var teamA_Deploy: TileGridBuilder.TGprop
var teamB_Deploy: TileGridBuilder.TGprop

func TakeIn_teams():
	teamA_Deploy= Control_Core.module_control.arena_builder.arena_material(Vector2i(teamA_size, 1), Vector2i(0,0))
	teamB_Deploy= Control_Core.module_control.arena_builder.arena_material(Vector2i(teamB_size, 1), Vector2i(6,11))
	
	var total_tilegrid=teamA_Deploy
	total_tilegrid.tilepack += teamB_Deploy.tilepack
	
	Control_Core.visual_control.base_tilemap.build_tilemap(total_tilegrid)
	Control_Core.visual_control.base_tilemap.recenter_tilegrid(Control_Core.get_media_size())
	
	var teamA_groups= Control_Core.module_control.object_control.new_robot_group("TeamA", teamA_size)
	reposition_robots(teamA_groups, teamA_Deploy)
	Control_Core.visual_control.game_object.add_group(teamA_groups, Control_Core.visual_control.base_tilemap)
	
	var teamB_groups= Control_Core.module_control.object_control.new_robot_group("TeamB", teamB_size)
	reposition_robots(teamB_groups, teamB_Deploy)
	Control_Core.visual_control.game_object.add_group(teamB_groups, Control_Core.visual_control.base_tilemap)

func reposition_robots(groups: Node, TGprop: TileGridBuilder.TGprop):
	var members= groups.get_children()
	for i in members.size():
		members[i].position= Control_Core.visual_control.base_tilemap.map_to_local(TGprop.tilepack[i])+Control_Core.visual_control.base_tilemap.position
