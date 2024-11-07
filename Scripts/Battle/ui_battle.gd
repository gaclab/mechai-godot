extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	get_node("TOPUI/Time/Timeleft")
	$EndTurn.pressed.connect(Callable(get_parent(),"_on_end_turn_pressed"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_time(time:Array):
	get_node("TOPUI/Time/Timeleft").text = "%02d" % time[1]
func update_turn_point(red,blue):
	pass
	get_node("TOPUI/Blue/TurnPoint").text = str(blue)
	get_node("TOPUI/Red/TurnPoint").text = str(red)
