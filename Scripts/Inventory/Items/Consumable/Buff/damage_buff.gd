class_name DamageBuff
extends Item

@export var extra_damage: int = 1
@export var max_turn: int = 3

func _ready() -> void:
	is_stackable = true
	is_consumable = true
	is_equipable = false

func heal() -> Array[int]:
	return [extra_damage, max_turn]
