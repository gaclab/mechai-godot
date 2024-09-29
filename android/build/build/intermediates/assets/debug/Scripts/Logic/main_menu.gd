extends Control

@export var modeSelection : PackedScene

func _on_play_pressed():
	get_tree().change_scene_to_packed(modeSelection)
