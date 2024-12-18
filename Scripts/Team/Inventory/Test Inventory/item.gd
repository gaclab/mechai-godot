@tool

class_name ItemTest
extends Resource

var minImgSize: int = 32

@export_group('Image')
@export var texture: Texture = null
@export_group('Property')
@export var name: String = ''
@export var description: String = ''
@export var quantity: int = 1
@export var isStack: bool = false
@export var isConsumeable: bool = false
@export var isEquipable: bool = false
















#@onready var image: Sprite2D = $Image
#
#func _ready() -> void:
	#image.texture = texture
	#
	#var original_size = texture.get_size()
	#var scale_factor = min(64 / original_size.x, 64 / original_size.y)
	#image.scale = Vector2(scale_factor, scale_factor)
