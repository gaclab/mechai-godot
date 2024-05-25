extends TileMap
var gridder = Vector2i(0,0)
@onready var zona_arena : Array[Vector2i] = get_used_cells(0)
var points : Curve2D
@export var sedang_menggambar = false
var astar_grid = AStarGrid2D.new()
var start = Vector2i(0,0)
var robots = {}
var packedpoints : PackedVector2Array

func _ready():
	$Unit.position = map_to_local(gridder)
	$Unit2.position = map_to_local(gridder + Vector2i.RIGHT * 1)
	$Unit3.position = map_to_local(gridder + Vector2i.RIGHT * 2)
	$Pergerakan.posisikan_indikator(map_to_local(gridder))

	var grid_size = zona_arena.max() - zona_arena.min() + Vector2i(1,1)
	astar_grid.size = grid_size
	astar_grid.cell_size = tile_set.tile_size
	astar_grid.offset = tile_set.tile_size/2 - (grid_size*tile_set.tile_size)/2
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.update()
	
	for child in find_children("*","Sprite2D"):
		robots[local_to_map(child.position)] = child

func _input(event):
	if event.is_action_pressed("ui_up"):
		gridder += Vector2i.UP
		$Pergerakan.posisikan_indikator(map_to_local(gridder))
	if event.is_action_pressed("ui_right"):
		gridder += Vector2i.RIGHT
		$Pergerakan.posisikan_indikator(map_to_local(gridder))
	if event.is_action_pressed("ui_left"):
		gridder += Vector2i.LEFT
		$Pergerakan.posisikan_indikator(map_to_local(gridder))
	if event.is_action_pressed("ui_down"):
		gridder += Vector2i.DOWN
		$Pergerakan.posisikan_indikator(map_to_local(gridder))
	if event.is_action_pressed("ui_home"):
		select_unit()

func select_unit():
		if !sedang_menggambar:
			if robots.has(gridder):
				sedang_menggambar = true
				$Pergerakan.target_yang_dipindahkan = robots[gridder]
		elif sedang_menggambar:
			if packedpoints.size() > 1:
				robots.erase(gridder)
				$Pergerakan.initpath()
				sedang_menggambar = false
			else:
				sedang_menggambar = false

func _process(delta):
	if !sedang_menggambar:
		start = gridder + Vector2i(5,5)
	else:
		if sedang_menggambar:
			if astar_grid.is_in_boundsv(gridder + Vector2i(5,5)):
				packedpoints = astar_grid.get_point_path(start, gridder + Vector2i(5,5))
				$Pergerakan.repath(packedpoints)

func _on_pergerakan_move_finished(last_pos):
	robots[local_to_map(last_pos)] = $Pergerakan.target_yang_dipindahkan
