extends TileGridBuilder
class_name ArenaBuilder

func arena_material(zone_size: Vector2i, from_pos: Vector2i):
	var result= TGprop.new()
	result.tilepack= get_filled_square(zone_size, from_pos)
	result.atlas_range= [Vector2.ZERO]
	result.IDTile= 1
	return result
