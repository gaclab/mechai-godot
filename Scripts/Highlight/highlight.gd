extends TileMapLayer
class_name Highlight


var zone : Array
@onready var exclude_loc : PackedVector2Array = [Vector2i(1,1),Vector2i(-1,-1),Vector2i(-1,1),Vector2i(1,-1)]
# Called when the node enters the scene tree for the first time.
var map_data :Map 
func _ready() -> void:
	#pass
	##set_cell(Vector2i(10,0),3,Vector2i(0,0),0)
	##print("phe")
	await get_tree().create_timer(2.0).timeout
	map_data = Global.battle.map
	position = map_data.position
	

	
func move_zone(object_loc:Vector2,range:int):
	clear()
	base_zone(range,3,object_loc,false,true)
	
func skill_zone(object_loc:Vector2,range:int):
	clear()
	base_zone(range,1,object_loc,false,false)

func skill_zone_enable_center(object_loc:Vector2,range:int):
	clear()
	base_zone(range,1,object_loc,true,false)

func attack_zone(object_loc:Vector2,range:int):
	clear()
	base_zone(range,2,object_loc,false,false)
	


func base_zone(range_action:int,tile_id:int,center_loc:Vector2,enable_center:bool,detect_solid:bool):
	pass
	clear()
	var zone_boundaries = create_bounds(center_loc,exclude_loc,range_action)
	create_zones(zone_boundaries,range_action,center_loc,enable_center)
	if !detect_solid:
		for tile in zone:
			if (
				map_data.astar.is_insideMap(tile)
				#and map_data.astar.get_astarPath(center_loc,tile).size()-1 <= range_action
				):
				set_cell(tile,tile_id,Vector2.ZERO,0)
	else :
		for tile in zone:
			#print(zone)
			var temp :PackedVector2Array = map_data.astar.get_astarPath(center_loc,tile)
			if (
				!map_data.astar.is_locationSolid(tile)
				and map_data.astar.is_insideMap(tile)
				and map_data.astar.get_astarPath(center_loc,tile).size()-1 <= range_action
			):
				print(temp)
				for fill in temp:
					var new_tile = local_to_map(fill)
					if new_tile not in get_used_cells():
						set_cell(new_tile,tile_id,Vector2.ZERO,0)
		if !enable_center:
			erase_cell(center_loc)
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
