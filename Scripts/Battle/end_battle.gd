extends Control


func _ready():
	visible = false


func _on_battle_manager_battle_ended(value):
	visible = true
	$VBoxContainer/the_winner.text = value


func _on_go_to_menu_button_down():
	Global.on_battle_end()
