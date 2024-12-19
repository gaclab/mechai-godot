extends Node
class_name NestedState

class state_dictionary:
	func OnMainMenu() -> STATE_OnMainMenu:
		return STATE_OnMainMenu.new()
	class STATE_OnMainMenu:
		var name = "OnMainMenu"
		
	func BattleNew() -> STATE_BattleNew:
		return STATE_BattleNew.new()
	class STATE_BattleNew:
		var name = "BattleNew"
		
	func DeployingRobot() -> STATE_DeployingRobot:
		return STATE_DeployingRobot.new()
	class STATE_DeployingRobot:
		var name = "DeployingRobot"
		
	func OnBattle() -> STATE_OnBattle:
		return STATE_OnBattle.new()
	class STATE_OnBattle:
		var name = "OnBattle"
var dictionary= state_dictionary.new()

func get_state_node(state_name: String):
	return get_node(state_name)
