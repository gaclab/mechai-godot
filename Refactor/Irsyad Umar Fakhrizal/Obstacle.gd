@tool
class_name Obstacles
extends Node2D

signal health_updated

enum PRIZE_TYPE {
	ZONK,
	ENERGY,
	HEALTH,
	ENERGY_HEALTH
}

var _helper_randType : int
var _visual_stand : Texture2D
var _visual_destroy : Texture2D 

#array untuk menyimpan semua textures
var obstacle : Array = [
	ResourceLoader.load("res://Assets/Sprites/Obstacles/Rock1.png"),
	ResourceLoader.load("res://Assets/Sprites/Obstacles/Rock2.png"),
	ResourceLoader.load("res://Assets/Sprites/Obstacles/Rock3.png"),
	ResourceLoader.load("res://Assets/Sprites/Obstacles/Rock4.png")
]
	
var obstacle_destroy : Array = [
	ResourceLoader.load("res://Assets/Sprites/Obstacles/Rock1_destroy.png"),
	ResourceLoader.load("res://Assets/Sprites/Obstacles/Rock2_destroy.png"),
	ResourceLoader.load("res://Assets/Sprites/Obstacles/Rock3_destroy.png"),
	ResourceLoader.load("res://Assets/Sprites/Obstacles/Rock4_destroy.png")
]

var _helper_prize : int
var _helper_once_get_prize : bool = false
#var prize_types : Dictionary = {
	#0: "zonk",
	#1: "energy",
	#2: "health",
	#3: "energy_health"
#} 

var hpObstacle : int = 2

@onready var destroy_animation = $AnimatedSprite2D 
@onready var hp_obstacle_bar = $solidbar
@onready var prizeEnergy : int = 0
@onready var prizeHealth : int = 0


#fungsi saat diattack
func onDamage(value : int)->void:
	if not hpObstacle == 0:  # Check both HP and click state
		hpObstacle -= value
	hp_obstacle_bar.value = hpObstacle
	check_destroy()
	get_prize()
	health_updated.emit(hpObstacle)
	
	
func get_prize():
	if hpObstacle == 0 :
		_helper_prize = randi_range(0,PRIZE_TYPE.size()-1)
		var prize : String = PRIZE_TYPE.values()[_helper_prize]
		
		match prize:
			PRIZE_TYPE.ZONK :
				pass
			PRIZE_TYPE.ENERGY :
				prizeEnergy = randi_range(1,2)
			PRIZE_TYPE.HEALTH :
				prizeHealth = randi_range(1,1)
			PRIZE_TYPE.ENERGY_HEALTH :
				prizeEnergy = randi_range(1,2)
				prizeHealth = randi_range(1,1)
				
	if not _helper_once_get_prize :
		$Obstacle.texture = _visual_destroy
		print("destroy")
			
	_helper_once_get_prize = true
			
		#if prize == "zonk" :
			#print("zonk")	
		#elif prize == "energy" :
			#prizeEnergy = randi_range(1,2)
			#print("energy : " ,prizeEnergy)
		#elif prize == "health" :
			#prizeHealth = randi_range(1,1)
			#print("health : " ,prizeHealth)
		#elif prize == "energy_health" :
			#prizeEnergy = randi_range(1,2)
			#print("energy : ", prizeEnergy)
			#prizeHealth = randi_range(1,1)
			#print("health : ",prizeHealth)
		
		
func check_destroy()->void:
	if hpObstacle == 0 :
		$AudioStreamPlayer.play()
		destroy_animation.visible = true
		destroy_animation.play("destroy")
		
		
func _ready():
	hp_obstacle_bar.max_value = hpObstacle
	hp_obstacle_bar.value = hpObstacle
	hp_obstacle_bar.visible = false
	_helper_randType = randi_range(0,3)
	_visual_stand = obstacle [_helper_randType]
	_visual_destroy = obstacle_destroy[_helper_randType]
	$Obstacle.texture = _visual_stand
	destroy_animation.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	if destroy_animation.is_playing():
		pass	
	elif not destroy_animation.is_playing() :
		destroy_animation.visible = false

func playanimatedspawn():
	$AnimationPlayer.play("DROPED")
	

func _on_area_2d_mouse_entered():
	if not hpObstacle == 0 :
		hp_obstacle_bar.visible = true


func _on_area_2d_mouse_exited():
	if hp_obstacle_bar.visible :
		hp_obstacle_bar.visible = false
