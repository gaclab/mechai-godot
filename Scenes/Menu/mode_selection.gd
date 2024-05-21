extends Control

@export var controlSelection : PackedScene

func _on_multiplayer_pressed():
	get_tree().change_scene_to_packed(controlSelection)


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")
