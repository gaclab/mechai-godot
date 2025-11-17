class_name RobotSlot
extends InventorySlot

@onready var robot_inventory: RobotInventory = (self.get_parent()).get_parent()

func _ready() -> void:
	parent_inventory = robot_inventory

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is not Object:
		return false
		
	return true

func load_data() -> void:
	if data_item:
		texture_rect.texture = data_item.texture
		label.text = str(data_item.quantity)
	else:
		texture_rect.texture = null
		label.text = ''
		clear_tooltip()
		return
	
	if data_item.quantity <= 0:
		texture_rect.texture = null
		label.text = ''
		parent_inventory.remove_item(slot_position)
	
	if data_item:
		update_tooltip(data_item.name, data_item.description)
