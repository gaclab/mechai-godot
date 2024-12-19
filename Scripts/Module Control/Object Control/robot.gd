extends Sprite2D
class_name Robot

@export var hp: int= 0
@export var atk: int= 0
@export var nested_state: NestedRobotState
var current_state: Node

func send_attack(target: Robot):
	target.input_damage(atk)

func input_damage(raw_damage:int):
	if hp> 0:
		hp-=raw_damage
	if hp <= 0:
		var state_dict= nested_state.dictionary
		current_state= nested_state.get_state_node(state_dict.Dead().name)
	$Label.text= str(current_state)
