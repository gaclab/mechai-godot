#@tool
#class_name Grid
#extends Resource
#
#@export var _mapSize = Vector2i(10,10)
#@export var _cellSize = Vector2i(64,64)
#
###cari Nilai tengah untuk menempatkan unit ditengah
#
#func HitungPosisiGrid(posisigrid : Vector2i)->Vector2i:
	#return (posisigrid * _cellSize )-Vector2i(320,320)
#
###kondisi true jika posisi cel berada dalam grid(Map)
#func is_inside_Map(posisisel : Vector2i)->bool:
	#var out : bool = posisisel.x >= 0 and posisisel.x < _mapSize.x
	#return out and posisisel.y >= 0 and posisisel.y < _mapSize.y
#
###Ubah posisi cell jika dia melebihi Map/Grid
#func PerbaikiPosisi(mapposition : Vector2i)->Vector2i:
	#var out := mapposition
	#out.x = clamp(out.x , 0 , _mapSize.x - 1.0)
	#out.y = clamp(out.y , 0 , _mapSize.y - 1.0)
	#return out
