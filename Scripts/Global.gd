extends Node

#preset templater (use sets loader)
#layer bug
#entering glitch bug
#vfx placement bug
#BattleSetup children script
var bugs : Dictionary
var debugsteer : Dictionary = {
	"Probability": {
		"Title click": {
			"InputEventMouseButton check": {
				"left-click check": {
					"Play pressed false": {  },
					"Options pressed false": {  },
					"Current tab 0 / Home": {  }
					}
				}
			},
		"Play click": {
			"Play pressed true": {  },
			"Options pressed false": {  },
			"Current tab 0 / BattleSetup": {  },
			"Clicka sound play": {  }
			},
		"Options click": {
			"Play pressed false": {  },
			"Options pressed true": {  },
			"Current tab 2 / Options": {  },
			"Clicka sound play": {  }
			},
		"Quit click": {
			#bug = quit confirm
			"Quit game": {  }
			},
		"Process exec": {
			"Global.is_battle_end check": {
				
				#bug = should self queue_free
				"Battle node queue_free": {  },
				
				"Current tab 0 / Home": {  },
				"Current tab 1 / Battle setup": {
					"Back click": {
						"BattleSetup tab reverse": {  },
						"Clickb sound play": {  }
						},
					"Go click": {
						"BattleSetup tab forward": {  },
						"Clicka sound play": {  }
						},
					"Current tab 0 / ModeSelect": {  }
					},
				"Global is_battle_end false": {  },
				"Main_menu show": {  }
				}
			}
		}
	}



signal created_battle()
var premaps = [
	[Vector2i(0, 3), Vector2i(1, 3), Vector2i(2, 3), Vector2i(3, 3), Vector2i(4, 3), Vector2i(5, 3), Vector2i(6, 3), Vector2i(7, 3), Vector2i(8, 3), Vector2i(9, 3), Vector2i(0, 6), Vector2i(1, 6), Vector2i(2, 6), Vector2i(3, 6), Vector2i(5, 6), Vector2i(4, 6), Vector2i(6, 6), Vector2i(7, 6), Vector2i(8, 6), Vector2i(9, 6), Vector2i(4, 7), Vector2i(5, 7), Vector2i(4, 8), Vector2i(5, 8), Vector2i(4, 2), Vector2i(5, 1), Vector2i(4, 1), Vector2i(5, 2), Vector2i(0, 5), Vector2i(0, 4), Vector2i(9, 5), Vector2i(9, 4)],
	[Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(1, 3), Vector2i(1, 4), Vector2i(1, 5), Vector2i(1, 6), Vector2i(1, 7), Vector2i(1, 8), Vector2i(1, 9), Vector2i(4, 0), Vector2i(4, 1), Vector2i(4, 2), Vector2i(4, 3), Vector2i(4, 4), Vector2i(4, 5), Vector2i(4, 6), Vector2i(4, 7), Vector2i(4, 8), Vector2i(4, 9), Vector2i(5, 1), Vector2i(5, 0), Vector2i(5, 2), Vector2i(5, 3), Vector2i(5, 4), Vector2i(5, 5), Vector2i(5, 6), Vector2i(5, 7), Vector2i(5, 8), Vector2i(5, 9), Vector2i(8, 0), Vector2i(8, 1), Vector2i(8, 3), Vector2i(8, 4), Vector2i(8, 2), Vector2i(8, 5), Vector2i(8, 6), Vector2i(8, 7), Vector2i(8, 8), Vector2i(8, 9)],
	[Vector2i(0, 3), Vector2i(1, 3), Vector2i(8, 3), Vector2i(9, 3), Vector2i(4, 6), Vector2i(5, 6), Vector2i(3, 5), Vector2i(2, 4), Vector2i(6, 5), Vector2i(7, 4), Vector2i(4, 7), Vector2i(5, 7), Vector2i(6, 8), Vector2i(7, 9), Vector2i(3, 8), Vector2i(2, 9), Vector2i(8, 2), Vector2i(9, 2), Vector2i(1, 2), Vector2i(0, 2), Vector2i(2, 1), Vector2i(3, 0), Vector2i(7, 1), Vector2i(6, 0), Vector2i(9, 4), Vector2i(9, 5), Vector2i(9, 6), Vector2i(9, 7), Vector2i(9, 8), Vector2i(9, 9), Vector2i(0, 4), Vector2i(0, 5), Vector2i(0, 6), Vector2i(0, 7), Vector2i(0, 8), Vector2i(0, 9), Vector2i(4, 5), Vector2i(5, 5), Vector2i(5, 4), Vector2i(4, 4), Vector2i(4, 3), Vector2i(5, 3), Vector2i(5, 2), Vector2i(4, 2), Vector2i(4, 1), Vector2i(5, 1), Vector2i(5, 0), Vector2i(4, 0)],
	[Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1), Vector2i(4, 1), Vector2i(5, 1), Vector2i(6, 1), Vector2i(7, 1), Vector2i(8, 1), Vector2i(8, 2), Vector2i(8, 3), Vector2i(8, 4), Vector2i(8, 5), Vector2i(8, 6), Vector2i(8, 7), Vector2i(8, 8), Vector2i(7, 8), Vector2i(6, 8), Vector2i(5, 8), Vector2i(4, 8), Vector2i(3, 8), Vector2i(2, 8), Vector2i(1, 8), Vector2i(1, 7), Vector2i(1, 6), Vector2i(1, 5), Vector2i(1, 4), Vector2i(1, 3), Vector2i(2, 3), Vector2i(3, 3), Vector2i(4, 3), Vector2i(5, 3), Vector2i(6, 3), Vector2i(6, 4), Vector2i(6, 5), Vector2i(6, 6), Vector2i(5, 6), Vector2i(4, 6), Vector2i(3, 6), Vector2i(3, 5), Vector2i(2, 2), Vector2i(4, 2), Vector2i(6, 2), Vector2i(7, 3), Vector2i(7, 5), Vector2i(7, 7), Vector2i(5, 7), Vector2i(3, 7), Vector2i(2, 6), Vector2i(2, 4), Vector2i(4, 4), Vector2i(5, 5), Vector2i(1, 0), Vector2i(3, 0), Vector2i(5, 0), Vector2i(7, 0), Vector2i(9, 0), Vector2i(9, 2), Vector2i(9, 4), Vector2i(9, 6), Vector2i(9, 8), Vector2i(8, 9), Vector2i(6, 9), Vector2i(4, 9), Vector2i(2, 9), Vector2i(0, 9), Vector2i(0, 7), Vector2i(0, 5), Vector2i(0, 3), Vector2i(0, 1)]
]

var selected_premap = 0
var obstacle_type :Battle.OBSTACLE_TYPE = 0
var is_battle_end : bool = false
var mode :Battle.MODE = 0
var environment : Battle.ENVIRONMENT_TYPE = 0
var conrol:Battle.CONTROLS = 2
var battle :Battle
func on_battle_start():
	battle = get_node("/root/Root/Battle")
	battle.battle_obstacle = obstacle_type
func _ready() -> void:
	created_battle.emit()
func clear_battle():
	pass

func on_battle_end(): # sementara karena kemungkinan ui berisi 3d akan ada , dan membutuhkan pembahasan tambahan
	pass
	is_battle_end = true
	#viewport.size = base_size*scale
	#get_window().content_scale_size = base_size
	#print(get_window().content_scale_size)
