extends TileMap
var gridder = Vector2i(0,0)
var locTemp : Vector2i
@onready var zona_arena : Array[Vector2i] = get_used_cells(0)
var points : Curve2D
@export var sedang_menggambar = false
var astar_grid = AStarGrid2D.new()
var start = Vector2i(0,0)
var robots = {}
var packedpoints : PackedVector2Array

var grid : Resource = load("res://Assets/Tres/Grid.tres")

var Obstacle = load("res://Scenes/Main scenes/obstacles.tscn").instantiate()
var Multiplayer : Resource = preload("res://Assets/Tres/MultiPlayerObstacle.tres")

func _ready():

	var grid_size = grid._mapSize
	var cell_size = grid._cellSize
	astar_grid.size = grid_size
	astar_grid.cell_size = cell_size
	astar_grid.offset = cell_size/2 - (grid_size*cell_size)/2
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.update()
	
	$Testunit.position = map_to_local(gridder)-Vector2((grid_size*cell_size)/2)
	$Testunit2.position = map_to_local(gridder + Vector2i.RIGHT * 1) -Vector2((grid_size*cell_size)/2)
	$Testunit3.position = map_to_local(gridder + Vector2i.RIGHT * 2) -Vector2((grid_size*cell_size)/2)
	$Pergerakan.posisikan_indikator(map_to_local(gridder) -Vector2(((grid_size*cell_size)/2)+cell_size/2))
	for child in find_children("*","Sprite2D"):
		if child.is_in_group("robot"):
			robots[local_to_map(child.position) + Vector2i(5,5)] = child
	
	#generate obstacle in multiplayer
	var obstacleLocation = Multiplayer._getMultiplayerLocation()
	for i in obstacleLocation.size() :
		var stack = Obstacle.duplicate()
		stack.set_cell(obstacleLocation[i])
		add_child(stack)
	
	
	
func _input(event):
	if event.is_action_pressed("ui_up"):
			gridder += Vector2i.UP
			$Pergerakan.posisikan_indikator(grid.HitungPosisiGrid(gridder))
	if event.is_action_pressed("ui_right"):
			gridder += Vector2i.RIGHT
			$Pergerakan.posisikan_indikator(grid.HitungPosisiGrid(gridder))
	if event.is_action_pressed("ui_left"):
			gridder += Vector2i.LEFT
			$Pergerakan.posisikan_indikator(grid.HitungPosisiGrid(gridder))
	if event.is_action_pressed("ui_down"):
			gridder += Vector2i.DOWN
			$Pergerakan.posisikan_indikator(grid.HitungPosisiGrid(gridder))
	if event.is_action_pressed("ui_home"):
		select_unit()
	if astar_grid.is_in_boundsv(gridder):
		pass
		

func select_unit():
		if !sedang_menggambar:
			if robots.has(gridder):
				sedang_menggambar = true
				print(gridder)
				$Pergerakan.target_yang_dipindahkan = robots[gridder]
		elif sedang_menggambar:
			if packedpoints.size() > 1:
				robots.erase(start)
				print(gridder)
				$Pergerakan.initpath()
				sedang_menggambar = false
			else:
				sedang_menggambar = false

func _process(delta):
	if !sedang_menggambar:
		start = gridder
		#print(start)
	else:
		if sedang_menggambar:
			if astar_grid.is_in_boundsv(gridder):
				packedpoints = astar_grid.get_point_path(start, gridder)
				#print(start, "  ", gridder)
				#print(packedpoints)
			
				$Pergerakan.repath(packedpoints)
				

func _on_pergerakan_move_finished(last_pos):
	
	robots[local_to_map(last_pos) + Vector2i(5,5)] = $Pergerakan.target_yang_dipindahkan
	
	
