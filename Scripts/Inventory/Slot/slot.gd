class_name InventorySlot
extends PanelContainer

@export var slot_position: int = 0

var data_item: Item

@onready var parent_inventory
@onready var texture_rect: TextureRect = $ItemImage
@onready var slot_container: GridContainer = %SlotContainer
@onready var label: Label = $ItemName

func _get_drag_data(_at_position: Vector2) -> Variant:
	if !data_item: return
	if data_item.quantity <= 0:
		return
	_mouse_preview()
	return self

func _drop_data(_at_position: Vector2, data_resource: Variant) -> void:
	var draged_data: Item = data_resource.data_item
	var item_added = parent_inventory.add_item(slot_container, draged_data, slot_position)
	if item_added:
		data_resource.load_data()

func clear_tooltip():
	tooltip_text = ''

func update_tooltip(title: String, desc: String) -> void:
	var inner_text = '%s\n%s' % [title, desc]
	tooltip_text = inner_text

func _mouse_preview() -> void:
	var preview_texture: TextureRect = TextureRect.new()
	preview_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview_texture.size = Vector2(40, 40)
	preview_texture.texture = texture_rect.texture
	
	var item_preview: Control = Control.new()
	item_preview.add_child(preview_texture)
	set_drag_preview(item_preview)
