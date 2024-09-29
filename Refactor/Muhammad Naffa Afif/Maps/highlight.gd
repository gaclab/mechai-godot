extends TileMapLayer
class_name Highlight


var zone : Array
@onready var exclude_loc : PackedVector2Array = [Vector2i(1,1),Vector2i(-1,-1),Vector2i(-1,1),Vector2i(1,-1)]
# Called when the node enters the scene tree for the first time.
@onready var Map_data :Map = get_parent()
#func _ready() -> void:
	#pass
	##set_cell(Vector2i(10,0),3,Vector2i(0,0),0)
	##print("phe")
	#await get_tree().create_timer(2.0).timeout
	
	
func move_zone(object_loc:Vector2,range:int):
	clear()
	base_zone(range,3,object_loc,false,true)
	
func skill_zone(object_loc:Vector2,range:int):
	clear()
	base_zone(range,1,object_loc,false,false)

func attack_zone(object_loc:Vector2,range:int):
	clear()
	base_zone(range,2,object_loc,false,false)
	


func base_zone(range_action:int,tile_id:int,center_loc:Vector2,enable_center:bool,detect_solid:bool):
	pass
	clear()
	var zone_boundaries = create_bounds(center_loc,exclude_loc,range_action)
	print(create_zones(zone_boundaries,range_action,center_loc,enable_center))
	if !detect_solid:
		for tile in zone:
			if (
				Map_data.astar.is_insideMap(tile)
				#and Map_data.astar.get_astarPath(center_loc,tile).size()-1 <= range_action
				):
				set_cell(tile,tile_id,Vector2.ZERO,0)
	else :
		for tile in zone:
			if (
				!Map_data.astar.is_locationSolid(tile)
				and Map_data.astar.is_insideMap(tile)
				and Map_data.astar.get_astarPath(center_loc,tile).size()-1 <= range_action
			):
				set_cell(tile,tile_id,Vector2.ZERO,0)
		
func create_zones(boundaries:PackedVector2Array,range_action:int,center_loc:Vector2,enable_center:bool)->PackedVector2Array:
	zone.clear()
	var up_loc : Vector2 = center_loc
	var right_loc : Vector2 = center_loc
	var down_loc : Vector2 = center_loc
	var left_loc : Vector2 = center_loc
	var up_right_loc : Vector2 
	var right_down_loc : Vector2 
	var left_down_loc : Vector2 
	var up_left_loc : Vector2 
	for i in range_action:
		up_loc = up_loc + Vector2.UP
		if !boundaries.has(up_loc):
			zone += [up_loc]
			up_right_loc = up_loc + Vector2.RIGHT
			while !boundaries.has(up_right_loc):
				zone += [up_right_loc]
				up_right_loc += Vector2.RIGHT
		right_loc = right_loc + Vector2.RIGHT
		if !boundaries.has(right_loc):
			zone += [right_loc]
			right_down_loc = right_loc + Vector2.DOWN
			while !boundaries.has(right_down_loc):
				zone += [right_down_loc]
				right_down_loc += Vector2.DOWN
		down_loc = down_loc + Vector2.DOWN
		if !boundaries.has(down_loc):
			zone += [down_loc]
			left_down_loc = down_loc + Vector2.LEFT
			while !boundaries.has(left_down_loc):
				zone += [left_down_loc]
				left_down_loc += Vector2.LEFT
		left_loc = left_loc + Vector2.LEFT
		if !boundaries.has(left_loc):
			zone += [left_loc]
			up_left_loc = left_loc + Vector2.UP
			while !boundaries.has(up_left_loc):
				zone += [up_left_loc]
				up_left_loc += Vector2.UP
	if enable_center :
		zone += [center_loc]
	return zone


func create_bounds(center_loc:Vector2,exclude_loc:PackedVector2Array,range:int)->PackedVector2Array:
	var zone_boundaries = []
	for corner in exclude_loc:
		for bound in range+1:
			if(corner == Vector2(1,1) or corner == Vector2(-1,-1)):
				var temp_zone = (Vector2(range-bound,bound+1)*corner+center_loc)
				zone_boundaries += [temp_zone]
				#set_cell(temp_zone,0,Vector2.ZERO,0)
			elif(corner == Vector2(-1,1) or corner == Vector2(1,-1)):
				var temp_zone = (Vector2(range-bound+1,bound)*corner+center_loc)
				zone_boundaries += [temp_zone]
				#set_cell(temp_zone,0,Vector2.ZERO,0)
	return zone_boundaries
	
func highligh(object_loc:Vector2i, type:String ,range:int):
	if not Engine.is_editor_hint():
		zone.clear()
		$Highlight.clear()
		var layer_type
		if type == "move" :
			layer_type = 0
		elif type == "attack" :
			layer_type = 1
		elif type == "skill" :
			layer_type = 2
		
		zone = [object_loc]
		var outsider = [Vector2i(1,1),Vector2i(-1,-1),Vector2i(-1,1),Vector2i(1,-1)]
		var highlight_range = range
		
		var change_cache = []
		while change_cache != zone:
			change_cache = zone
			var highlight_border = []
			for k in outsider:
				for i in highlight_range+1:
					highlight_border += [(Vector2i(highlight_range-i, i)*k)+object_loc]
					#$Highlight.set_cell(1,zone[0],0,Vector2i(0,0))
			
			$Highlight.set_cell(layer_type,zone[0],0,Vector2i(0,0))
			
			#for i in zone:
				#if !highlight_border.has(i):
					#if !zone.has(i+Vector2i.UP):
						#if astar_grid.is_in_boundsv(i+Vector2i.UP):
							#if !astar_grid.is_point_solid(i+Vector2i.UP) and layer_type == 0:
								#$Highlight.set_cell(layer_type,i+Vector2i.UP,0,Vector2i(0,0))
								#zone += [i+Vector2i.UP]
							#elif astar_grid.is_point_solid(i+Vector2i.UP) and layer_type == 1 :
								#if team == "redTeam" and robots_manager.robots["redTeam"]["object"].has(i+Vector2i.UP):
									#$Highlight.set_cell(1,i+Vector2i.UP,0,Vector2i(0,0))
									#zone += [i+Vector2i.UP]
									#astar_grid.set_point_solid(i+Vector2i.UP,true)
								#elif team =="blueTeam" and robots_manager.robots["blueTeam"]["object"].has(i+Vector2i.UP):
									#$Highlight.set_cell(1,i+Vector2i.UP,0,Vector2i(0,0))
									#zone += [i+Vector2i.UP]
									#astar_grid.set_point_solid(i+Vector2i.UP,true)
								#else:
									#$Highlight.set_cell(3,i+Vector2i.UP,0,Vector2i(0,0))
									#zone += [i+Vector2i.UP]
									#astar_grid.set_point_solid(i+Vector2i.UP,true)
							#elif astar_grid.is_point_solid(i+Vector2i.UP) and layer_type == 2 :
								#if team == "redTeam" and robots_manager.robots["redTeam"]["object"].has(i+Vector2i.UP):
									#$Highlight.set_cell(2,i+Vector2i.UP,0,Vector2i(0,0))
									#zone += [i+Vector2i.UP]
									#astar_grid.set_point_solid(i+Vector2i.UP,true)
								#elif team =="blueTeam" and robots_manager.robots["blueTeam"]["object"].has(i+Vector2i.UP):
									#$Highlight.set_cell(2,i+Vector2i.UP,0,Vector2i(0,0))
									#zone += [i+Vector2i.UP]
									#astar_grid.set_point_solid(i+Vector2i.UP,true)
								#else:
									#$Highlight.set_cell(3,i+Vector2i.UP,0,Vector2i(0,0))
									#zone += [i+Vector2i.UP]
									#astar_grid.set_point_solid(i+Vector2i.UP,true)
							#elif !astar_grid.is_point_solid(i+Vector2i.UP) :
								#$Highlight.set_cell(1,i+Vector2i.UP,0,Vector2i(0,0))
								#zone += [i+Vector2i.UP]
						#
					#if !zone.has(i+Vector2i.DOWN):
						#if astar_grid.is_in_boundsv(i+Vector2i.DOWN):
							#if !astar_grid.is_point_solid(i+Vector2i.DOWN) and layer_type == 0:
								#$Highlight.set_cell(layer_type,i+Vector2i.DOWN,0,Vector2i(0,0))
								#zone += [i+Vector2i.DOWN]
							#elif astar_grid.is_point_solid(i+Vector2i.DOWN) and layer_type == 1:
								#if team == "redTeam" and robots_manager.robots["redTeam"]["object"].has(i+Vector2i.DOWN):
									#$Highlight.set_cell(1,i+Vector2i.DOWN,0,Vector2i(0,0))
									#zone += [i+Vector2i.DOWN]
									#astar_grid.set_point_solid(i+Vector2i.DOWN,true)
								#elif team =="blueTeam" and robots_manager.robots["blueTeam"]["object"].has(i+Vector2i.DOWN):
									#$Highlight.set_cell(1,i+Vector2i.DOWN,0,Vector2i(0,0))
									#zone += [i+Vector2i.DOWN]
									#astar_grid.set_point_solid(i+Vector2i.DOWN,true)
								#else:
									#$Highlight.set_cell(3,i+Vector2i.DOWN,0,Vector2i(0,0))
									#zone += [i+Vector2i.DOWN]
									#astar_grid.set_point_solid(i+Vector2i.DOWN,true)
							#elif astar_grid.is_point_solid(i+Vector2i.DOWN) and layer_type == 2:
								#if team == "redTeam" and robots_manager.robots["redTeam"]["object"].has(i+Vector2i.DOWN):
									#$Highlight.set_cell(2,i+Vector2i.DOWN,0,Vector2i(0,0))
									#zone += [i+Vector2i.DOWN]
									#astar_grid.set_point_solid(i+Vector2i.DOWN,true)
								#elif team =="blueTeam" and robots_manager.robots["blueTeam"]["object"].has(i+Vector2i.DOWN):
									#$Highlight.set_cell(2,i+Vector2i.DOWN,0,Vector2i(0,0))
									#zone += [i+Vector2i.DOWN]
									#astar_grid.set_point_solid(i+Vector2i.DOWN,true)
								#else:
									#$Highlight.set_cell(3,i+Vector2i.DOWN,0,Vector2i(0,0))
									#zone += [i+Vector2i.DOWN]
									#astar_grid.set_point_solid(i+Vector2i.DOWN,true)
							#elif !astar_grid.is_point_solid(i+Vector2i.DOWN) :
								#$Highlight.set_cell(1,i+Vector2i.DOWN,0,Vector2i(0,0))
								#zone += [i+Vector2i.DOWN]
					#
					#if !zone.has(i+Vector2i.LEFT):
						#if astar_grid.is_in_boundsv(i+Vector2i.LEFT):
							#if !astar_grid.is_point_solid(i+Vector2i.LEFT) and layer_type == 0:
								#$Highlight.set_cell(layer_type,i+Vector2i.LEFT,0,Vector2i(0,0))
								#zone += [i+Vector2i.LEFT]
							#elif astar_grid.is_point_solid(i+Vector2i.LEFT) and layer_type == 1:
								#if team == "redTeam" and robots_manager.robots["redTeam"]["object"].has(i+Vector2i.LEFT):
									#$Highlight.set_cell(1,i+Vector2i.LEFT,0,Vector2i(0,0))
									#zone += [i+Vector2i.LEFT]
									#astar_grid.set_point_solid(i+Vector2i.LEFT,true)
								#elif team =="blueTeam" and robots_manager.robots["blueTeam"]["object"].has(i+Vector2i.LEFT):
									#$Highlight.set_cell(1,i+Vector2i.LEFT,0,Vector2i(0,0))
									#zone += [i+Vector2i.LEFT]
									#astar_grid.set_point_solid(i+Vector2i.LEFT,true)
								#else:
									#$Highlight.set_cell(3,i+Vector2i.LEFT,0,Vector2i(0,0))
									#zone += [i+Vector2i.LEFT]
									#astar_grid.set_point_solid(i+Vector2i.LEFT,true)
							#elif astar_grid.is_point_solid(i+Vector2i.LEFT) and layer_type == 2:
								#if team == "redTeam" and robots_manager.robots["redTeam"]["object"].has(i+Vector2i.LEFT):
									#$Highlight.set_cell(2,i+Vector2i.LEFT,0,Vector2i(0,0))
									#zone += [i+Vector2i.LEFT]
									#astar_grid.set_point_solid(i+Vector2i.LEFT,true)
								#elif team =="blueTeam" and robots_manager.robots["blueTeam"]["object"].has(i+Vector2i.LEFT):
									#$Highlight.set_cell(2,i+Vector2i.LEFT,0,Vector2i(0,0))
									#zone += [i+Vector2i.LEFT]
									#astar_grid.set_point_solid(i+Vector2i.LEFT,true)
								#else:
									#$Highlight.set_cell(3,i+Vector2i.LEFT,0,Vector2i(0,0))
									#zone += [i+Vector2i.LEFT]
									#astar_grid.set_point_solid(i+Vector2i.LEFT,true)
							#elif !astar_grid.is_point_solid(i+Vector2i.LEFT) :
								#$Highlight.set_cell(1,i+Vector2i.LEFT,0,Vector2i(0,0))
								#zone += [i+Vector2i.LEFT]
#
					#if !zone.has(i+Vector2i.RIGHT):
						#if astar_grid.is_in_boundsv(i+Vector2i.RIGHT):
							#if !astar_grid.is_point_solid(i+Vector2i.RIGHT) and layer_type == 0:
								#$Highlight.set_cell(layer_type,i+Vector2i.RIGHT,0,Vector2i(0,0))
								#zone += [i+Vector2i.RIGHT]
							#elif astar_grid.is_point_solid(i+Vector2i.RIGHT) and layer_type == 1:
								#if team == "redTeam" and robots_manager.robots["redTeam"]["object"].has(i+Vector2i.RIGHT):
									#$Highlight.set_cell(1,i+Vector2i.RIGHT,0,Vector2i(0,0))
									#zone += [i+Vector2i.RIGHT]
									#astar_grid.set_point_solid(i+Vector2i.RIGHT,true)
								#elif team =="blueTeam" and robots_manager.robots["blueTeam"]["object"].has(i+Vector2i.RIGHT):
									#$Highlight.set_cell(1,i+Vector2i.RIGHT,0,Vector2i(0,0))
									#zone += [i+Vector2i.RIGHT]
									#astar_grid.set_point_solid(i+Vector2i.RIGHT,true)
								#else:
									#$Highlight.set_cell(3,i+Vector2i.RIGHT,0,Vector2i(0,0))
									#zone += [i+Vector2i.RIGHT]
									#astar_grid.set_point_solid(i+Vector2i.RIGHT,true)
							#elif astar_grid.is_point_solid(i+Vector2i.RIGHT) and layer_type == 2:
								#if team == "redTeam" and robots_manager.robots["redTeam"]["object"].has(i+Vector2i.RIGHT):
									#$Highlight.set_cell(2,i+Vector2i.RIGHT,0,Vector2i(0,0))
									#zone += [i+Vector2i.RIGHT]
									#astar_grid.set_point_solid(i+Vector2i.RIGHT,true)
								#elif team =="blueTeam" and robots_manager.robots["blueTeam"]["object"].has(i+Vector2i.RIGHT):
									#$Highlight.set_cell(2,i+Vector2i.RIGHT,0,Vector2i(0,0))
									#zone += [i+Vector2i.RIGHT]
									#astar_grid.set_point_solid(i+Vector2i.RIGHT,true)
								#else:
									#$Highlight.set_cell(3,i+Vector2i.RIGHT,0,Vector2i(0,0))
									#zone += [i+Vector2i.RIGHT]
									#astar_grid.set_point_solid(i+Vector2i.RIGHT,true)
							#elif !astar_grid.is_point_solid(i+Vector2i.RIGHT):
								#$Highlight.set_cell(1,i+Vector2i.RIGHT,0,Vector2i(0,0))
								#zone += [i+Vector2i.RIGHT]
