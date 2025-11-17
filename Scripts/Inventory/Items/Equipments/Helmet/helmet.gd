class_name Helmet
extends Item

@export_group('Damage Reduction')
@export_enum("Aggresive", "Balance", "Defensive") var type: String = ''

var health: int
var defense: int

func _ready() -> void:
	is_stackable = false
	is_consumable = false
	is_equipable = true
	
	match type:
		"Aggresive":
			health = -0.4
			defense = 2
		"Balance":
			health = 0
			defense = 1
		"Defensive":
			health = 3
			defense = 0
		_:
			health = 0
			defense = 0

func Block(dmg_total: int) -> int:
	return dmg_total - defense
