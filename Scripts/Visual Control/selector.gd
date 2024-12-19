extends AnimatedSprite2D
class_name Selector

var tilegrid_owner: TileGrid
var event_position: Vector2
var gridded_event_position: Vector2

func event_motion(event_pos:Vector2):
	if Control_Core.visual_control.arena_tilemap.is_in_here(event_pos):
		position= Control_Core.visual_control.arena_tilemap.align_position(event_pos)
		tilegrid_owner= Control_Core.visual_control.arena_tilemap
		event_position= event_pos
		gridded_event_position= position
		visible= true
	elif Control_Core.visual_control.base_tilemap.is_in_here(event_pos):
		position= Control_Core.visual_control.base_tilemap.align_position(event_pos)
		tilegrid_owner= Control_Core.visual_control.base_tilemap
		event_position= event_pos
		gridded_event_position= position
		visible= true
	else:
		position= event_pos
		tilegrid_owner= null
		event_position= event_pos
		visible= false



#selector validator
#highlight system #checkpoint
