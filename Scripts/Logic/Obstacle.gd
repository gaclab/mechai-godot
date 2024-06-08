@tool
class_name Obstacles
extends Node2D


var hpObstacle : int = 0:
	get:
		return hpObstacle

var is_stand : bool = true;

#fungsi saat diattack
func onDamage(value : int)->void:
	if hpObstacle != 0:  # Check both HP and click state
		hpObstacle = hpObstacle - value;
	$Lifebar.value = hpObstacle
	
#fungsi cek obstacle hancur
func check_destroy()->void:
	if hpObstacle == 0 :
		is_stand = false
		
func _input(event : InputEvent)->void:
	#if event.is_action("u") and event.is_pressed() and not event.is_echo():
		#onDamage(1)
	pass

func _ready():
	hpObstacle = 5;
	$Lifebar.max_value = hpObstacle
	$Lifebar.value = hpObstacle
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_destroy()
	if is_stand :
		$Obstacle.texture = ResourceLoader.load("res://Assets/Sprites/Batu-sementara.png")
	else :
		$Obstacle.texture = ResourceLoader.load("res://Assets/Sprites/Batu-hancur-sementara.png")
