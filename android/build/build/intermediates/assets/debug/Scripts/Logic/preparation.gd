extends Control

signal nextState()

func _on_ready_button_down():
	nextState.emit()
	queue_free()
	
	
