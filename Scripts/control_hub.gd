extends Node
class_name ControlHub

#predefined level dictionary #predefined recorder
#predefined di node asal
#meminimalkan game control itu utama
#return value ke game control (dan modul asal) itu utama
#visual control dan game control bisa saling suruh
#variable error = tolerable
#class name error = not tolerable
#uses of connector 
	#classname change precaution
#script declaration order

func _ready() -> void:
	var global_nodes = get_children()
	for node in global_nodes:
		if node is VisualControl:
			Control_Core.visual_control= node
		elif node is ModuleControl:
			Control_Core.module_control= node
		elif node is GameControl:
			Control_Core.game_control= node
		elif node is TimeControl:
			Control_Core.time_control= node
	
	Control_Core.game_control.prepare()
	Control_Core.visual_control.prepare()
	Control_Core.module_control.prepare()
