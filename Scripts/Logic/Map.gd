@tool
extends TileMap
var gridder = Vector2i(0,0)
var points : Curve2D
var sedang_menggambar = false
var astar_grid = AStarGrid2D.new()
var start = Vector2i(0,0)
var robots = {}
var packedpoints : PackedVector2Array
@onready var ukuran_jendela = get_window().size + Vector2i(0,23)

var Obstacle = load("res://Scenes/Main scenes/obstacles.tscn").instantiate()
var Multiplayer : Resource = preload("res://Assets/Tres/MultiPlayerObstacle.tres")

@export var Bake = false :
	set(val) : generate_ulang_map()
func generate_ulang_map():
	clear()
	position = ((ukuran_jendela) - (tile_set.tile_size*tile_set._mapSize))/2
	var lokasi_pojok = (-(ukuran_jendela) + (tile_set.tile_size*tile_set._mapSize))/2
	var lokasi_pojok_snapped = local_to_map(lokasi_pojok)
	while lokasi_pojok_snapped.y <= local_to_map(ukuran_jendela+lokasi_pojok).y:
		var tempx = lokasi_pojok_snapped.x
		while lokasi_pojok_snapped.x <= local_to_map(ukuran_jendela+lokasi_pojok).x:
			
			if	(
				lokasi_pojok_snapped.y >= 0 and lokasi_pojok_snapped.y < tile_set._mapSize.y
				and 
				lokasi_pojok_snapped.x >= 0 and lokasi_pojok_snapped.x < tile_set._mapSize.x
				):
				set_cell(0,lokasi_pojok_snapped,1,Vector2i(34,1))
			else:
				set_cell(1,lokasi_pojok_snapped,1,Vector2i(35,3))
			
			lokasi_pojok_snapped.x += 1
		lokasi_pojok_snapped.y += 1
		lokasi_pojok_snapped.x = tempx

func _ready():
	#Ketika script berjalan didalam game
	if not Engine.is_editor_hint():
	#
	
		prerender()
	
	#inisialisasi astar_grid
		astar_grid.size = tile_set._mapSize # setting ukuran peta
		astar_grid.cell_size = tile_set._cellSize # setting ukuran kolom
		astar_grid.offset = tile_set._cellSize/2 # setting offset astar_grid
		#setting algoritma astar_grid
		astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
		astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
		astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
		#
		astar_grid.update() #update astar_grid
	#

	#peletakan posisi indikator
		$Pergerakan.posisikan_indikator(map_to_local(gridder))
	#

	#bagian generate obstacle
		#generate obstacle in multiplayer
		var obstacleLocation = Multiplayer._getMultiplayerLocation(self) #ambil posisi seluruh obstacle
		for i in obstacleLocation:
			var stack : Obstacles = Obstacle.duplicate() #duplikasi objek obstacle
			stack.position = map_to_local(i) #memposisikan setiap obstacle
			add_child(stack) #menambahkan setiap obstacle kedalam tree
			astar_grid.set_point_solid(i,true)
	#
	
	#peletakan posisi unit
		var unitorium = [$Testunit, $Testunit2, $Testunit3]
		var arena_zone = get_used_cells(0)
		for u in unitorium:
			var found = false
			for p in arena_zone:
				if !found:
					if !astar_grid.is_point_solid(p):
						u.position = map_to_local(p)
						astar_grid.set_point_solid(p)
						found = true
	#
	
	#pengumpulan seluruh objek robot menjadi array
		for child in find_children("*","Sprite2D"):
			if child.is_in_group("robot"):
				robots[local_to_map(child.position)] = child
	#

func _input(event):
	#ketika script berjalan didalam game
	if not Engine.is_editor_hint():
	#
	
	#jika input(event) adalah sebuah tombol keyboard
		if event is InputEventKey:
	#
	
	#kalkulasi arah gridder berdasarkan input
			if event.is_action_pressed("ui_up"):
					gridder += Vector2i.UP
			elif event.is_action_pressed("ui_right"):
					gridder += Vector2i.RIGHT
			elif event.is_action_pressed("ui_left"):
					gridder += Vector2i.LEFT
			elif event.is_action_pressed("ui_down"):
					gridder += Vector2i.DOWN
	#
	
	#pencegahan agar indikator tidak keluar arena
			if astar_grid.is_in_boundsv(gridder):
				$Pergerakan.posisikan_indikator(map_to_local(gridder))
			else:
				gridder = local_to_map($Pergerakan.get_posisi_indikator())
	#
	
	#input ketika indikator memilih robot
			if event.is_action_pressed("ui_home"):
				select_unit()
	#
	
	#refresh ulang tampilan
			prerender()
	#

func select_unit():
	#ketika select ->
	if !sedang_menggambar:
		if $Pergerakan.target_yang_dipindahkan == null: #cek apakah pergerakan sudah selesai
			if robots.has(gridder): #cek apakah array memiliki robot dari lokasi yang sama
				
				#set selected robot
				sedang_menggambar = true
				$Pergerakan.target_yang_dipindahkan = robots[gridder]
				#
	
	#-ketika unselect ->
	elif sedang_menggambar:
		if packedpoints.size() > 1: #cek apakah pergerakan lebih dari 1
			$Pergerakan.initpath() #robot akan bergerak
			sedang_menggambar = false #stop menggambar
			robots.erase(start) #robot akan dihapus dari array
			astar_grid.set_point_solid(start,false)
		else:
			#--
			$Pergerakan.target_yang_dipindahkan = null
			sedang_menggambar = false #stop menggambar
	#

#alur =
#-jika lebih dari 1 akan menggambar
func prerender():
	if !sedang_menggambar:
		start = gridder
	else:
		if sedang_menggambar:
			if astar_grid.is_in_boundsv(gridder):
				packedpoints = astar_grid.get_point_path(start, gridder)
				$Pergerakan.repath(packedpoints)
				

#ketika selesai bergerak ->
func _on_pergerakan_move_finished(last_robot : Node2D):
	robots[local_to_map(last_robot.position)] = last_robot #lokasi terakhir robot akan ditambahkan ke array
	astar_grid.set_point_solid(local_to_map(last_robot.position))
#
