@tool
class_name Grid
extends Resource

@export var mapSize = Vector2(10,10)
@export var cellSize = Vector2(64,64)

##cari Nilai tengah untuk menempatkan unit ditengah
var centerCell = cellSize/2

##hitung posisi tengah sel ke pixel
func HitungPosisi(posisigrid : Vector2) ->Vector2:
	return posisigrid * cellSize + centerCell

##hitung posisi cell dalam map
func HitungPosisiMap(mapposition : Vector2) ->Vector2:
	return (mapposition / cellSize).floor()

func HitungPosisiGrid(posisigrid : Vector2)->Vector2:
	return (posisigrid*cellSize)-Vector2(320,320)

##kondisi true jika posisi cel berada dalam grid(Map)
func is_inside_Map(posisisel : Vector2)->bool:
	var out : bool = posisisel.x >= 0 and posisisel.x < mapSize.x
	return out and posisisel.y >= 0 and posisisel.y < mapSize.y

##Ubah posisi cell jika dia melebihi Map/Grid
func PerbaikiPosisi(mapposition : Vector2)->Vector2:
	var out := mapposition
	out.x = clamp(out.x , 0 , mapSize.x - 1.0)
	out.y = clamp(out.y , 0 , mapSize.y - 1.0)
	return out
