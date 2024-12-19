extends STATE
class_name RMOD_STATS

#attacking
#stats manipulation and stats
@export var state: Node
@export var health: int= 0
@export var attack: int= 0

class state_ref:
	func OFF() -> STATE_OFF:
		return STATE_OFF.new()
	class STATE_OFF:
		var name = "OFF"
	
	func ON() -> STATE_ON:
		return STATE_ON.new()
	class STATE_ON:
		var name = "ON"
	
	func DEAD() -> STATE_DEAD:
		return STATE_DEAD.new()
	class STATE_DEAD:
		var name = "DEAD"
var states= state_ref.new()

func receive_damage(raw_damage:int):
	if health > 0:
		health-=raw_damage
	elif health <= 0:
		state= $DEAD
	get_parent().update_indicator()

func turn_on():
	if state != $ON:
		state= $ON

func request_attack(target: Robot):
	ControlCore.GameObject.send_attack(target, attack)
