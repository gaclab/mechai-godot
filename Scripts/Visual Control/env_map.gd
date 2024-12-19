extends TileMapLayer
class_name BattleEnvirontment

func recenter_environtment() -> void:
	position= Control_Core.visual_control.arena_tilemap.position
	get_node("Sprite2D").global_position = Control_Core.get_media_size()/2
