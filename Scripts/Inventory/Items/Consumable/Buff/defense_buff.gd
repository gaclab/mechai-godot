class_name DefenseBuff
extends Item

@export var extra_defense: int = 1
@export var max_turn: int = 3

func _ready() -> void:
	is_stackable = true
	is_consumable = true
	is_equipable = false

func buff() -> Array[int]:
	return [extra_defense, max_turn]
