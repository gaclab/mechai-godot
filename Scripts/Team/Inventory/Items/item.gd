@tool

class_name Item
extends Resource

#var maxImgSize: int = 16

@export_group('Image')
@export var texture: CompressedTexture2D = null
@export_group('Property')
@export var name: String = ''
@export var description: String = ''
@export var quantity: int = 0
@export var isStackable: bool = false
@export var isConsumable: bool = false
@export var isEquipable: bool = false

func initAll(node: Node) -> void:
	if not node:
		print('no node')
		return
		
	for child in node.get_children():
		if child.name == 'Texture':
			child.texture = texture

func substract(totalUsed: int):
	quantity -= totalUsed
	












#@onready var image: Sprite2D = $Image
#
#func _ready() -> void:
	#image.texture = texture
	#
	#var original_size = texture.get_size()
	#var scale_factor = min(64 / original_size.x, 64 / original_size.y)
	#image.scale = Vector2(scale_factor, scale_factor)
