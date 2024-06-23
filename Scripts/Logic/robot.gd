class_name robot
extends Node2D
signal death(value: robot)
signal destroy(value: robot)
signal enemy_attacked(damage:int)

enum RobotState {UNDEPLOYED,DEPLOYED,TURN,WAITTURN,ENDTURN,ATTACK,SKILL,MOVE,IDLE,DEATH,DESTROYED}
var stats : Resource = load("res://Assets/Tres/default_robot_stats.tres")

@onready var robotState: int
@onready var health : int = 0 :
	set (value):
		if health <= 10 :
			health += value
			if health > 10:
				health = 10
			if health < 0:
				health = 0
			
@onready var armor : int 
@onready var energy : int = 0 : 
	set (value):
		if energy <= 10 :
			energy += value
			if energy > 10 :
				energy = 10
			if energy < 0:
				energy = 0
@onready var attackDamage : int 
@onready var skillDamage : int 
@onready var moveRange : int 
@onready var attackRange : int 
@onready var skillRange : int
@onready var moveEnergy: int
@onready var attackEnergy: int
@onready var skillEnergy: int
@onready var solidHp : int

var _helper_prize : int
@onready var prizeEnergy : int = 0
@onready var prizeHealth : int = 0

var _helper_was_death : bool = false
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
	solidHp = stats.solidBar
	$hp_bar.max_value = health
	$hp_bar.value = health
	$energy_bar.max_value = energy
	$energy_bar.value = energy
	$solid_bar.value = solidHp
	$solid_bar.max_value = solidHp
	$solid_bar.visible = false
	$AnimatedSprite2D.visible = false

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
		_:
			robotState = 10

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
	print(robotState)
	if robotState != 9 :
		if health > 0 :
			health = -damageEnemy
			$hp_bar.value = health
		if health <= 0:
			set_robot_state(RobotState.DEATH)
			# kasih animasi
			death.emit(self)
			$solid_bar.visible = true
			$hp_bar.visible = false
			$energy_bar.visible = false
			if !_helper_was_death :
				$AnimatedSprite2D.visible = true
				$AnimatedSprite2D.play("Smoke")
				_helper_was_death = true
	else :
		if solidHp > 0 :
			solidHp -= 1
			$solid_bar.value = solidHp
		if solidHp <=0:
			$AnimatedSprite2D.position = Vector2.ZERO
			$AnimatedSprite2D.play("Explosion")
			_helper_prize = randi_range(0,3)
			if _helper_prize == 0 :
				print("zonk")
			elif _helper_prize == 1 :
				prizeEnergy = randi_range(1,2)
				print("energy : " ,prizeEnergy)
			elif _helper_prize == 2 :
				prizeHealth = randi_range(1,1)
				print("health : " ,prizeHealth)
			else :
				prizeEnergy = randi_range(1,2)
				print("energy : ", prizeEnergy)
				prizeHealth = randi_range(1,1)
				print("health : ",prizeHealth)
			set_robot_state(RobotState.DESTROYED)
			destroy.emit(self)
			$solid_bar.visible = false
			$robot_sprite.texture = load("res://Assets/Sprites/Batu-hancur-sementara.png")
			await get_tree().create_timer(0.5).timeout
			$AnimatedSprite2D.stop()
			$AnimatedSprite2D.visible = false
	


func attack_enemy():
	enemy_attacked.emit(attackDamage)
func skill_enemy():
	enemy_attacked.emit(skillDamage)
func consume_energy(value:int,multiple:int):
	if energy > 0 :
		energy = -(value*multiple)
		if energy < 0 :
			energy = 0
	$energy_bar.value = energy

func restore_energy():
	if robotState == 8 :
		energy = 4
		if energy > 10 :
			energy = 10
		$energy_bar.value = energy
	else :
		energy = 2
		if energy > 10 :
			energy = 10
		$energy_bar.value = energy
func get_health()->int:
	return health
	
func get_new_value_attribute():
	$hp_bar.value = health
	$energy_bar.value = energy
