extends Control

@export var map : PackedScene

func _on_battle_pressed():
	get_tree().change_scene_to_packed(map)


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/mode_selection.tscn")
