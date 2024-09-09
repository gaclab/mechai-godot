extends Resource
class_name Level_Template
@export var _level_location : PackedVector2Array
#ambil lokasi obstacle yang telah ditentukan
func _getLevelLocation()->PackedVector2Array:
	return _level_location
