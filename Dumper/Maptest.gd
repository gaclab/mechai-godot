@export var barp = false


func printer():
	print("aws")

#func _ready():
	#var winsz = get_window().size + Vector2i(0,23)
	#clear()
	#var windower = (winsz/2) - (tile_set.tile_size*5)
	#position = windower
	#
	#var repos = local_to_map(-(winsz/2) + (tile_set.tile_size*5))
	#
	#while repos.y <= local_to_map(winsz-(winsz/2) + (tile_set.tile_size*5)).y:
		#var tempy = repos.x
		#while repos.x <= local_to_map(winsz-(winsz/2) + (tile_set.tile_size*5)).x:
			#set_cell(1,repos,1,Vector2i(35,3))
			#repos.x += 1
		#repos.y += 1
		#repos.x = tempy
#
	#for y in 10:
		#for x in 10:
			#erase_cell(1,Vector2i(x,y))
			#set_cell(1,Vector2i(x,y),1,Vector2i(34,1))
#
#
##func _on_timer_timeout():
	###clear()
	##if map_to_local(Vector2i(x,1)).x < get_window().size.x - map_to_local(Vector2i(10,1)).x:
		##set_cell(1,Vector2i(x,1),1,Vector2i(35,3))
		##x+=1
	##else:
		##clear()
		##x=0
