@tool
class_name Obstacles
extends Node2D

var _helper_randType : int
var _visual_stand : Texture2D
var _visual_destroy : Texture2D
var _helper_prize : int
@onready var prizeEnergy : int = 0
@onready var prizeHealth : int = 0
var _helper_once_get_prize : bool = false
var hpObstacle : int = 0:
	get:
		return hpObstacle

var is_stand : bool = true;

#fungsi saat diattack
func onDamage(value : int)->void:
	if hpObstacle != 0:  # Check both HP and click state
		hpObstacle = hpObstacle - value;
	$solidbar.value = hpObstacle
	check_destroy()
	
	
#fungsi cek obstacle hancur
func check_destroy()->void:
	if hpObstacle == 0 :
		$AnimatedSprite2D.visible = true
		$AnimatedSprite2D.play("destroy")
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
		if !_helper_once_get_prize :
			$Obstacle.texture = _visual_destroy
			print("hancur")
		is_stand = false
		_helper_once_get_prize = true
		
		

func _ready():
	hpObstacle = 2;
	$solidbar.max_value = hpObstacle
	$solidbar.value = hpObstacle
	$solidbar.visible = false
	_helper_randType = randi_range(1,4)
	if _helper_randType == 1 :
		_visual_stand = ResourceLoader.load("res://Assets/Sprites/Obstacles/Rock1_1.png")
		_visual_destroy = ResourceLoader.load("res://Assets/Sprites/Obstacles/rock1hancur.png")
	if _helper_randType == 2 :
		_visual_stand = ResourceLoader.load("res://Assets/Sprites/Obstacles/Rock2_1.png")
		_visual_destroy = ResourceLoader.load("res://Assets/Sprites/Obstacles/Rock2_hancur.png")
	if _helper_randType == 3 :
		_visual_stand = ResourceLoader.load("res://Assets/Sprites/Obstacles/Rock5_1.png")
		_visual_destroy = ResourceLoader.load("res://Assets/Sprites/Obstacles/rock5hancur.png")
	if _helper_randType == 4 :
		_visual_stand = ResourceLoader.load("res://Assets/Sprites/Obstacles/Rock6_1.png")
		_visual_destroy = ResourceLoader.load("res://Assets/Sprites/Obstacles/rock6hancur.png")
	$Obstacle.texture = _visual_stand
	$AnimatedSprite2D.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	if $AnimatedSprite2D.is_playing():
		pass
	else :
		$AnimatedSprite2D.visible = false

func playanimatedspawn():
	$AnimationPlayer.play("DROPED")
	


func _on_area_2d_mouse_entered():
	if hpObstacle != 0 :
		$solidbar.visible = true



func _on_area_2d_mouse_exited():
	if $solidbar.visible :
		$solidbar.visible = false
