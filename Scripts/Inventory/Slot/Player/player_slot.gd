class_name PlayerSlot
extends InventorySlot

@onready var player_inventory: PlayerInventory = (self.get_parent()).get_parent()

func _ready() -> void:
	parent_inventory = player_inventory

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is not Object:
		return false
	if not data_item:
		return false
	if data.data_item.name == data_item.name:
		return true
	return false

func load_data() -> void:
	texture_rect.texture = data_item.texture
	label.text = str(data_item.quantity)
	
	if data_item:
		update_tooltip(data_item.name, data_item.description)
