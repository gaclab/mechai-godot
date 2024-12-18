@tool

class_name Armour
extends Item

@export_group('Damage Reduction')
@export_enum('aggresive', 'Balance', 'Defensive') var type: String = ''
@export var SHORT = 2
@export var LAUNCHER = 1
@export var SNIPER = 0

func _ready() -> void :
	var dmgBlocked: int = block('short', 10)
	print(dmgBlocked)

func block(dmg_type: String, dmg_total: int) -> int:
	var reduce_dmg: int
	
	match dmg_type:
		'short':
			reduce_dmg = SHORT
		'launcher':
			reduce_dmg = LAUNCHER
		'sniper':
			reduce_dmg = SNIPER
		_:
			reduce_dmg = 0;
	
	return dmg_total - reduce_dmg
