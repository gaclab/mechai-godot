extends Button
var blues = []
var redies = []

func recount():
	for blue in blues.size():
		if blue == 0:
			if blues[blue].robotState == 9:
				$Blue/HBoxContainer/VBoxContainer/Ut/HBoxContainer/R1/Panel.size_flags_horizontal = SIZE_SHRINK_CENTER
			else:
				$Blue/HBoxContainer/VBoxContainer/Ut/HBoxContainer/R1/Panel.size_flags_horizontal = SIZE_FILL
		if blue == 1:
			if blues[blue].robotState == 9:
				$Blue/HBoxContainer/VBoxContainer/Ut/HBoxContainer/R2/Panel.size_flags_horizontal = SIZE_SHRINK_CENTER
			else:
				$Blue/HBoxContainer/VBoxContainer/Ut/HBoxContainer/R2/Panel.size_flags_horizontal = SIZE_FILL
		if blue == 2:
			if blues[blue].robotState == 9:
				$Blue/HBoxContainer/VBoxContainer/Ut/HBoxContainer/R3/Panel.size_flags_horizontal = SIZE_SHRINK_CENTER
			else:
				$Blue/HBoxContainer/VBoxContainer/Ut/HBoxContainer/R3/Panel.size_flags_horizontal = SIZE_FILL
	
	for red in redies.size():
		if red == 0:
			if redies[red].robotState == 9:
				$Red/HBoxContainer/VBoxContainer/Ut/HBoxContainer/R1/Panel.size_flags_horizontal = SIZE_SHRINK_CENTER
			else:
				$Red/HBoxContainer/VBoxContainer/Ut/HBoxContainer/R1/Panel.size_flags_horizontal = SIZE_FILL
		if red == 1:
			if redies[red].robotState == 9:
				$Red/HBoxContainer/VBoxContainer/Ut/HBoxContainer/R2/Panel.size_flags_horizontal = SIZE_SHRINK_CENTER
			else:
				$Red/HBoxContainer/VBoxContainer/Ut/HBoxContainer/R2/Panel.size_flags_horizontal = SIZE_FILL
		if red == 2:
			if redies[red].robotState == 9:
				$Red/HBoxContainer/VBoxContainer/Ut/HBoxContainer/R3/Panel.size_flags_horizontal = SIZE_SHRINK_CENTER
			else:
				$Red/HBoxContainer/VBoxContainer/Ut/HBoxContainer/R3/Panel.size_flags_horizontal = SIZE_FILL
