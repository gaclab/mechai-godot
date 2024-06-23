extends TabContainer


func _on_back_pressed():
	current_tab -= 1
	$clickb.play()


func _on_go_pressed():
	current_tab += 1
	$clicka.play()
