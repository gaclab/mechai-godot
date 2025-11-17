class_name Repair
extends Item

@export var repaired_health: int = 5

func _ready() -> void:
	is_stackable = true
	is_consumable = true
	is_equipable = false

func heal() -> int:
	return repaired_health
