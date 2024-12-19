extends Node
class_name TileGridBuilder

class TGprop:
	var tilepack: PackedVector2Array
	var atlas_range: PackedVector2Array
	var IDTile: int

func get_filled_square(size: Vector2i, from: Vector2i):
	var result: PackedVector2Array= []
	for x in range(size.x):
		for y in range(size.y):
			result.append(from + Vector2i(x,y))
			#self.set_cell(Vector2i(x,y),1,Vector2i(0,0),0)
	return result
