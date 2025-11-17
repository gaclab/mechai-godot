class_name PlayerInventory
extends Inventory

@warning_ignore("unused_signal")
signal refresh_inventory

@onready var player_slot_container: GridContainer = %SlotContainer

func _ready() -> void:
	assign_to_slot(player_slot_container)

func add_item(slot_container: GridContainer, drag_item: Item, pos: int) -> bool:
	var item_duplicate: Item = drag_item.duplicate(true)
	item_duplicate.quantity = 1
	
	if Items[pos] and item_duplicate.name == Items[pos].name:
		Items[pos].quantity += 1
	elif Items[pos]:
		return false
	else:
		return false
	
	drag_item.quantity -= 1
	assign_to_slot(slot_container)
	emit_signal("refresh_inventory")
	return true

func assign_to_slot(slot_container: GridContainer) -> void:
	if !Items:
		return
	
	var slots = slot_container.get_children()
	var i: int = 0
	for item: Item in Items:
		if item == null:
			continue
		
		var slot = slots[i]
		if slot:
			slot.data_item = item
			slot.load_data()
			i += 1
