extends Node
class_name TimeControl

@export var deploy_timer: Timer

func prepare():
	#to manually connect
	pass

func start_deploy_timer(time: float, loop: bool):
	deploy_timer.one_shot= !loop
	deploy_timer.start(time)
