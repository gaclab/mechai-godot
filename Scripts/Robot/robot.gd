class_name Robot
extends Node2D
signal death(value: Robot)
signal destroy(value: Robot)
signal enemy_attacked(damage:int)

enum ROBOT_CONDITION {FREE,STUNED}
enum ROBOT_ACTION {ATTACK,SKILL,MOVE,IDLE}
enum ROBOT_STATUS {UNDEPLOYED,DEPLOYED,TURN,UNTURN,DEATH,DESTROYED}
enum ROBOT_SKILL_TARGET {SELF,TEAM,ENEMY}
var healing_skill : bool = false
var defense_skill : bool = false
var attack_skill : bool = false
var target_skill : Array[ROBOT_SKILL_TARGET]
var healingValue = 1
var defenseValue = 1
var ranged_skill :bool = false
var stats : Resource = load("res://Assets/Tres/default_robot_stats.tres")
var actionPoint : Dictionary = {'move':true,'attack':true,'skill':true} #move attack skill if in future want to change number its okey
@onready var robotStatus: ROBOT_STATUS = ROBOT_STATUS.UNDEPLOYED
@onready var robotAction:ROBOT_ACTION = ROBOT_ACTION.IDLE
@onready var robotCondition: ROBOT_CONDITION = ROBOT_CONDITION.FREE
var robotTeam : Team.StrongHolds
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
var robot_map_loc : Vector2i

func custom_init():
	pass
func _ready():
	self.z_index = 11
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
	attack_skill = true
	healing_skill = true
	defense_skill = false
	ranged_skill = true
	target_skill = [ROBOT_SKILL_TARGET.ENEMY]
	$hp_bar.max_value = health
	$hp_bar.value = health
	$energy_bar.max_value = energy
	$energy_bar.value = energy
	$solid_bar.value = solidHp
	$solid_bar.max_value = solidHp
	$solid_bar.visible = false
	$AnimatedSprite2D.visible = false
	

func get_data()->Dictionary:
	var Temp :Dictionary = {
		"health" : health,
		"armor" : armor,
		"energy" : energy,
		"attack" : attackDamage,
		"skill" : skillDamage,
		"atkrange" : attackRange,
		"skillrange" : skillRange,
		"mrange" : moveRange,
		"moveenergy" : moveEnergy,
		"atkenergy" : attackEnergy,
		"skillenergy" : skillEnergy,
		"Status" : ROBOT_STATUS.keys()[robotStatus],
		"Action" : ROBOT_ACTION.keys()[robotAction],
		"Condition" : ROBOT_CONDITION.keys()[robotCondition],
		"Team" : Team.StrongHolds.keys()[robotTeam]
	}
	
	return Temp

func on_damaged(damageEnemy : int):
	#calculation enemy damage base on armor
	#print(robotStatus)
	if robotStatus != ROBOT_STATUS.DEATH :
		if health > 0 :
			health = -damageEnemy
			$hp_bar.value = health
		if health <= 0:
			$death.play()
			robotStatus = ROBOT_STATUS.DEATH
			# kasih animasi
			death.emit(self)
			$solid_bar.visible = true
			$hp_bar.visible = false
			$energy_bar.visible = false
			if !_helper_was_death :
				$AnimatedSprite2D.global_position = global_position - Vector2(0,64)
				$AnimatedSprite2D.visible = true
				$AnimatedSprite2D.play("Smoke")
				_helper_was_death = true
	else :
		if solidHp > 0 :
			solidHp -= 1
			$solid_bar.value = solidHp
		if solidHp <=0:
			$destroy.play()
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
			destroy.emit(self)
			$solid_bar.visible = false
			$robot_sprite.texture = load("res://Assets/Sprites/Robot/Batu-hancur-sementara.png")
			await get_tree().create_timer(0.5).timeout
			$AnimatedSprite2D.stop()
			$AnimatedSprite2D.visible = false
			robotStatus = ROBOT_STATUS.DESTROYED
			Global.battle.tile_data[Global.battle.tile_data.find_key(self)] = null
	


func attack_enemy(target:Robot):
	if robotAction != ROBOT_ACTION.SKILL:
		robotAction = ROBOT_ACTION.ATTACK
	if Battle.TURN_STATE.keys()[Global.battle.turn_state] + 'TEAM' != target.get_parent().name:
		consume_energy(attackEnergy,1)
		$attack.play()
		$AnimatedSprite2D.show()
		$AnimatedSprite2D.position = Global.battle.map.tile_map.map_to_local(target.robot_map_loc) - position - Vector2(0,32)
		$AnimatedSprite2D.play("Attack")
		target.on_damaged(attackDamage)
		change_robot_status(ROBOT_STATUS.TURN)
		print(get_parent().name,' the ',name , ' attacked the : ',target.name ,' of ',target.get_parent().name, ' with ',attackDamage,' damaged')
		await get_tree().create_timer(1.0).timeout
		$AnimatedSprite2D.hide()
		$AnimatedSprite2D.position = position
	if robotAction == ROBOT_ACTION.ATTACK: 
		actionPoint['attack'] = false
	robotAction = ROBOT_ACTION.IDLE
func consume_energy(value:int,multiple:int):
	if energy > 0 :
		energy = -(value*multiple)
		if energy < 0 :
			energy = 0
	$energy_bar.value = energy

func on_turn_change():#update for control when turn or unturn
	print('masuk on turn change')
	if robotStatus == ROBOT_STATUS.TURN:
		restore_energy()
		actionPoint['move'] = true
		actionPoint['attack'] = true
		actionPoint['skill'] = true
		robotStatus = ROBOT_STATUS.UNTURN
	elif robotStatus == ROBOT_STATUS.UNTURN:
		restore_energy()
		actionPoint['move'] = true
		actionPoint['attack'] = true
		actionPoint['skill'] = true

func change_robot_status(status:ROBOT_STATUS):
	robotStatus = status

func restore_energy():
	if robotStatus == ROBOT_STATUS.UNTURN :
		energy = 4
		if energy > 10 :
			energy = 10
		$energy_bar.value = energy
		print('robot : ',self.name,' mendapat 4 energy')
	else :
		energy = 2
		if energy > 10 :
			energy = 10
		$energy_bar.value = energy
		print('robot : ',self.name,' mendapat 2 energy')

func get_health()->int:
	return health
	
func get_new_value_attribute():
	$hp_bar.value = health
	$energy_bar.value = energy

func move_robot(current_loc:Vector2i,target_loc:Vector2i): #opsional Update Afif
	robotAction = ROBOT_ACTION.MOVE
	if Global.battle.tile_data[target_loc] == null :
		#print(current_loc)
		var astarpath = Global.battle.map.astar.get_astarPath(current_loc,target_loc)
		#print(astarpath)
		Global.battle._update_tile_data(current_loc,target_loc,self)
		Global.battle.map.path.repath(astarpath)
		Global.battle.map.path.initPath(self,500.0)
		consume_energy(moveEnergy,astarpath.size()-1)
		change_robot_status(ROBOT_STATUS.TURN)
		robot_map_loc = target_loc
		
	robotAction = ROBOT_ACTION.IDLE
	actionPoint['move'] = false
func use_skill(target,target_loc): #opsional Update Afif
	consume_energy(skillEnergy,1)
	change_robot_status(ROBOT_STATUS.TURN)
	robotAction = ROBOT_ACTION.SKILL
	if is_instance_of(target,Robot):
		if healing_skill :
			if ranged_skill:
				Global.battle.control.highlight.skill_zone_enable_center(target_loc,skillRange)
				for i in Global.battle.control.highlight.get_used_cells():
					var tempTarget = Global.battle.tile_data[i]	
					if is_instance_of(tempTarget,Robot) and tempTarget.get_parent().name == get_parent().name:
						tempTarget.on_healed(healingValue)
			else:
				target.on_healed(healingValue)
		if attack_skill :
			if ranged_skill:
				Global.battle.control.highlight.skill_zone_enable_center(target_loc,skillRange)
				for i in Global.battle.control.highlight.get_used_cells():
					#print(i)
					var tempTarget = Global.battle.tile_data[i]	
					if is_instance_of(tempTarget,Robot) and tempTarget.get_parent().name != get_parent().name:
						$skill.play()
						$AnimatedSprite2D.position = Global.battle.map.tile_map.map_to_local(tempTarget.robot_map_loc) - position
						$AnimatedSprite2D.show()
						$AnimatedSprite2D.play("Skill")
						tempTarget.on_damaged(skillDamage)
						await get_tree().create_timer(1.0).timeout
						$AnimatedSprite2D.hide()
						$AnimatedSprite2D.position = position
			else:
				$skill.play()
				$AnimatedSprite2D.position = Global.battle.map.tile_map.map_to_local(target.robot_map_loc) - position
				$AnimatedSprite2D.show()
				$AnimatedSprite2D.play("Skill")
				target.on_damaged(skillDamage)
				await get_tree().create_timer(1.0).timeout
				$AnimatedSprite2D.hide()
				$AnimatedSprite2D.position = position
		if defense_skill :
			if ranged_skill:
				Global.battle.control.highlight.skill_zone_enable_center(target_loc,skillRange)
				for i in Global.battle.control.highlight.get_used_cells():
					var tempTarget = Global.battle.tile_data[i]	
					if is_instance_of(tempTarget,Robot) and tempTarget.get_parent().name == get_parent().name:
						tempTarget.on_defensed(defenseValue)
			else:
				self.on_defensed(defenseValue)
	elif is_instance_of(target,Obstacle):
		if healing_skill :
			if ranged_skill:
				Global.battle.control.highlight.skill_zone_enable_center(target_loc,skillRange)
				for i in Global.battle.control.highlight.get_used_cells():
					var tempTarget = Global.battle.tile_data[i]	
					if is_instance_of(tempTarget,Robot) and tempTarget.get_parent().name == get_parent().name:
						tempTarget.on_healed(healingValue)
			else:
				target.on_healed(healingValue)
		if attack_skill :
			$skill.play()
			if is_instance_of(target,Obstacle):
				$AnimatedSprite2D.position = Global.battle.map.tile_map.map_to_local(target.pos_in_map) - position
			else:
				$AnimatedSprite2D.position = Global.battle.map.tile_map.map_to_local(target.robot_map_loc) - position
			$AnimatedSprite2D.show()
			$AnimatedSprite2D.play("Skill")
			attack_obstacle(target,true)
			await get_tree().create_timer(1.0).timeout
			$AnimatedSprite2D.hide()
			$AnimatedSprite2D.position = position
		if defense_skill :
			self.on_defensed(defenseValue)
	elif target == null : # can update to custom tile , with some discussion
		if healing_skill :
			if ranged_skill:
				Global.battle.control.highlight.skill_zone_enable_center(target_loc,skillRange)
				for i in Global.battle.control.highlight.get_used_cells():
					var tempTarget = Global.battle.tile_data[i]	
					if is_instance_of(tempTarget,Robot) and tempTarget.get_parent().name == get_parent().name:
						tempTarget.on_healed(healingValue)
			else:
				target.on_healed(healingValue)
		if attack_skill :
			if ranged_skill:
				Global.battle.control.highlight.skill_zone_enable_center(target_loc,skillRange)
				for i in Global.battle.control.highlight.get_used_cells():
					#print(i)
					var tempTarget = Global.battle.tile_data[i]	
					if is_instance_of(tempTarget,Robot) and tempTarget.get_parent().name != get_parent().name:
						$skill.play()
						$AnimatedSprite2D.position = Global.battle.map.tile_map.map_to_local(tempTarget.robot_map_loc) - position
						$AnimatedSprite2D.show()
						$AnimatedSprite2D.play("Skill")
						tempTarget.on_damaged(skillDamage)
						await get_tree().create_timer(1.0).timeout
						$AnimatedSprite2D.hide()
						$AnimatedSprite2D.position = position
		if defense_skill :
			self.on_defensed(defenseValue)
	await get_tree().create_timer(0.5).timeout
	Global.battle.control.highlight.clear()
	robotAction = ROBOT_ACTION.IDLE
	actionPoint['skill'] = false
	
func attack_obstacle(target:Obstacle,with_skill:bool):
	if robotAction != ROBOT_ACTION.SKILL:
		$attack.play()
		robotAction = ROBOT_ACTION.ATTACK
		$AnimatedSprite2D.show()
		$AnimatedSprite2D.position = Global.battle.map.tile_map.map_to_local(target.pos_in_map) - position - Vector2(0,32)
		$AnimatedSprite2D.play("Attack")
		await get_tree().create_timer(1.0).timeout
		$AnimatedSprite2D.hide()
		$AnimatedSprite2D.position = position
	else:
		$skill.play()
	consume_energy(attackEnergy,1)
	target.on_damaged(1)
	change_robot_status(ROBOT_STATUS.TURN)
	print(get_parent().name,' the ',name , ' attacked the : Obstacle with node ',target, 'with 1 damaged')
	if robotAction == ROBOT_ACTION.ATTACK: 
		actionPoint['attack'] = false
	robotAction = ROBOT_ACTION.IDLE

func on_healed(healValue):
	print('nyawa awal : ',health,' dan di heal : ',healingValue)
	health = healingValue
	$hp_bar.value = health

func on_defensed(defenseValue):
	armor += defenseValue

func on_deployed():
	#if robotTeam == Team.StrongHolds.RED:
		#$robot_sprite.rotation = 180
	#else : 
		#$robot_sprite.rotation = 0
	robotStatus = ROBOT_STATUS.DEPLOYED
	$Deploy.play()
	$AnimatedSprite2D.show()
	$AnimatedSprite2D.position = Global.battle.map.tile_map.map_to_local(robot_map_loc) - position - Vector2(0,64)
	$AnimatedSprite2D.play('Deploy')
	await get_tree().create_timer(1.0).timeout
	$AnimatedSprite2D.hide()
	$AnimatedSprite2D.position = position - Global.battle.map.position
