@tool

class_name Weapon
extends Item

@export_group('Damage')
@export_enum("Short", "Launcher", "Sniper") var type: String

var damage: int
var range: int
var shape: String
var stamina_consumption: int

func _ready() -> void:
	match type:
		"Short":
			damage = 3
			range = 2
			shape = 'Square'
			stamina_consumption = 1
		"Launcher":
			damage = 2
			range = 4
			shape = 'Diamond'
			stamina_consumption = 1
		"Sniper":
			damage = 1
			range = 6
			shape = 'Cross'
			stamina_consumption = 1
