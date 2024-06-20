class_name robot
extends Node2D
signal death(value: robot)
signal enemy_attacked(damage:int)

enum RobotState {UNDEPLOYED,DEPLOYED,TURN,WAITTURN,ENDTURN,ATTACK,SKILL,MOVE,IDLE,DEATH}
var stats : Resource = load("res://Assets/Tres/default_robot_stats.tres")

@onready var robotState: int
@onready var health : int 
@onready var armor : int 
@onready var energy : int 
@onready var attackDamage : int 
@onready var skillDamage : int 
@onready var moveRange : int 
@onready var attackRange : int 
@onready var skillRange : int
@onready var moveEnergy: int
@onready var attackEnergy: int
@onready var skillEnergy: int


func _ready():
	health = stats.health
	armor = stats.armor
	energy = stats.energy
	attackDamage = stats.attackDamage
	skillDamage = stats.skillDamage
	moveRange = stats.moveRange
	attackRange = stats.attackRange
	skillRange = stats.skillRange
	moveEnergy = stats.moveEnergy
	attackEnergy = stats.attackEnergy
	skillEnergy = stats.skillEnergy
	$hp_bar.max_value = health
	$hp_bar.value = health
	$energy_bar.max_value = energy
	$energy_bar.value = energy

func set_robot_state(stateName : RobotState):
	match stateName:
		RobotState.UNDEPLOYED :
			robotState = 0
		RobotState.DEPLOYED :
			robotState = 1
		RobotState.TURN :
			robotState = 2
		RobotState.WAITTURN :
			robotState = 3
		RobotState.ENDTURN :
			robotState = 4
		RobotState.ATTACK :
			robotState = 5
		RobotState.SKILL :
			robotState = 6
		RobotState.MOVE :
			robotState = 7
		RobotState.IDLE:
			robotState = 8
		RobotState.DEATH:
			robotState = 9

func get_robot_datas()->Dictionary:
	var Temp :Dictionary = {
		"robotState" : robotState,
		"health" : health,
		"armor" : armor,
		"energy" : energy,
		"attackDamage" : attackDamage,
		"skillDamage" : skillDamage,
		"attackRange" : attackRange,
		"skillRange" : skillRange,
		"moveRange" : moveRange,
		"moveEnergy" : moveEnergy,
		"attackEnergy" : attackEnergy,
		"skillEnergy" : skillEnergy
	}
	
	return Temp

func on_damaged(damageEnemy : int):
	if health > 0 :
		health -= damageEnemy
		$hp_bar.value = health
	if health <= 0:
		set_robot_state(RobotState.DEATH)
		# kasih animasi
		death.emit(self)


func attack_enemy():
	enemy_attacked.emit(attackDamage)
func skill_enemy():
	enemy_attacked.emit(skillDamage)
func consume_energy(value:int,multiple:int):
	if energy > 0 :
		energy -= value*multiple
		if energy < 0 :
			energy = 0
	$energy_bar.value = energy

func restore_energy():
	if robotState == 8 :
		energy += 4
		if energy > 10 :
			energy = 10
		$energy_bar.value = energy
	else :
		energy += 2
		if energy > 10 :
			energy = 10
		$energy_bar.value = energy
