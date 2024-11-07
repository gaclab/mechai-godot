extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_information(data:Dictionary):
	$Container/Value/health.text = str(data['health'])
	$Container/Value/armor.text = str(data['armor'])
	$Container/Value/energy.text = str(data['energy'])
	$Container/Value/atk.text = str(data['attack'])
	$Container/Value/skill.text = str(data['skill'])
	$Container/Value/mrange.text = str(data['mrange'])
	$Container/Value/atkrange.text = str(data['atkrange'])
	$Container/Value/skillrange.text = str(data['skillrange'])
	$Container/Value/moveenergy.text = str(data['moveenergy'])
	$Container/Value/atkenergy.text = str(data['atkenergy'])
	$Container/Value/skillenergy.text = str(data['skillenergy'])
	$Container/Value/Action.text = str(data['Action'])
	$Container/Value/Status.text = str(data['Status'])
	$Container/Value/Condition.text = str(data['Condition'])
	$Container/Value/Team.text = str(data['Team'])
