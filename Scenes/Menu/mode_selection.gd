extends Control

@export var controlSelection : PackedScene



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_multiplayer_pressed():
	get_tree().change_scene_to_packed(controlSelection)
