@tool

class_name Equipment
extends Item

@export_group('Damage Reduction')
@export_enum("Aggresive", "Balance", "Defensive") var type: String = ''

var health: int
var defense: int

func _ready() -> void :
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
	
	var block: int = Block('short', 10)
	print(block)

func Block(dmg_type: String, dmg_total: int) -> int :	
	#return dmg_total - DamageReduce
	return 0
