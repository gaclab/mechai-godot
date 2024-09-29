extends Control

@onready var health = $health_container/health_value
@onready var armor = $armor_container/armor_value
@onready var energy = $energy_container/energy_value
@onready var state = $robot_state/stateval
@onready var moveRange = $moveRange/mrangeval
@onready var attackRange = $attackRange/atkrangeval
@onready var skillRange = $skillRange/skillrangeval
@onready var attackDamage = $attackDmg_container/atk_value
@onready var skillDamage = $skillDmg_container/skill_value
@onready var moveEnergy = $move_energy/moveenergyval
@onready var attackEnergy = $attack_energy/atkenergyval
@onready var skillEnergy = $skill_energy/skillenergyval



func set_info(temp : Dictionary):
	state.text = str(temp["robotState"])
	health.text = str(temp["health"])
	armor.text = str(temp["armor"])
	energy.text = str(temp["energy"])
	moveRange.text = str(temp["moveRange"])
	attackRange.text = str(temp["attackRange"]) 
	skillRange.text = str(temp["skillRange"])
	moveEnergy.text = str(temp["moveEnergy"])
	attackEnergy.text = str(temp["attackEnergy"]) 
	skillEnergy.text = str(temp["skillEnergy"])
	attackDamage.text = str(temp["attackDamage"]) 
	skillDamage.text = str(temp["skillDamage"])
