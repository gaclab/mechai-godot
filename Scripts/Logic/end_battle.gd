extends Control


func _ready():
	visible = false



func _on_battle_manager_battleended(value):
	visible = true
	$VBoxContainer/the_winner.text = value


func _on_go_to_menu_button_down():
	visible = false
