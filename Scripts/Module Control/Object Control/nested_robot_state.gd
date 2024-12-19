extends Node
class_name NestedRobotState

class state_dictionary:
	func Idle() -> STATE_Idle:
		return STATE_Idle.new()
	class STATE_Idle:
		var name = "Idle"
		
	func Busy() -> STATE_Busy:
		return STATE_Busy.new()
	class STATE_Busy:
		var name = "Busy"
		
	func Dead() -> STATE_Dead:
		return STATE_Dead.new()
	class STATE_Dead:
		var name = "Dead"
		
var dictionary= state_dictionary.new()

func get_state_node(state_name: String):
	return get_node(state_name)
