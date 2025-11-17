class_name Item
extends Resource

@export_group('Image')
@export var texture: CompressedTexture2D = null
@export_group('Property')
@export var name: String = ''
@export var description: String = ''
@export var quantity: int = 0
@export var is_stackable: bool = false
@export var is_consumable: bool = false
@export var is_equipable: bool = false

func substract(total_used: int) -> void:
	quantity -= total_used

func str() -> String:
	return "Item Name: " + name + ", Value: " + str(quantity)
