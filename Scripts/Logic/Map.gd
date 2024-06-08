@tool
extends TileMap

signal managed_action(robot : Node2D, value :Array) # nanti diganti ketika sudah ada robot

@onready var actionoption = $"action-option"
@onready var action_option_move = $"action-option/move"
@onready var action_option_attack = $"action-option/attack"
@onready var action_option_skill = $"action-option/skill"
var _is_action_selected : bool # untuk kondisi ketika action dipilih
var _helpper_is_play : bool = false # indikator untuk mencegah aksi ketika robot digerakkan
var _helper_hover:bool=false # indikator supaya selama crusor diatas menu action maka tidak bisa select 
var _temp_action_point : Array = [1,1,1]
var _helper_selected_action : String; # indikator untuk menyimpan action terakhir yang dipilih guna menyesuaikan kebutuhan
var gridder = Vector2i(0,0)
var points : Curve2D
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

var vesorus = [Vector2i(5,5)]
var maxrnge = 3
func highlight():
	var maxrray = []
	for i in maxrnge:
		maxrray += [Vector2(maxrnge-i, i)]
	print(maxrray)
	
	for i in vesorus:
		if !vesorus.has(i+Vector2i.UP):
			if astar_grid.is_in_boundsv(i+Vector2i.UP):
				if !astar_grid.is_point_solid(i+Vector2i.UP):
					set_cell(1,i+Vector2i.UP,1,Vector2i(35,3))
					vesorus += [i+Vector2i.UP]
			
		if !vesorus.has(i+Vector2i.DOWN):
			if astar_grid.is_in_boundsv(i+Vector2i.DOWN):
				if !astar_grid.is_point_solid(i+Vector2i.DOWN):
					set_cell(1,i+Vector2i.DOWN,1,Vector2i(35,3))
					vesorus += [i+Vector2i.DOWN]
		
		if !vesorus.has(i+Vector2i.LEFT):
			if astar_grid.is_in_boundsv(i+Vector2i.LEFT):
				if !astar_grid.is_point_solid(i+Vector2i.LEFT):
					set_cell(1,i+Vector2i.LEFT,1,Vector2i(35,3))
					vesorus += [i+Vector2i.LEFT]

		if !vesorus.has(i+Vector2i.RIGHT):
			if astar_grid.is_in_boundsv(i+Vector2i.RIGHT):
				if !astar_grid.is_point_solid(i+Vector2i.RIGHT):
					set_cell(1,i+Vector2i.RIGHT,1,Vector2i(35,3))
					vesorus += [i+Vector2i.RIGHT]
		

func _ready():
	#Ketika script berjalan didalam game
	if not Engine.is_editor_hint():
		#set_cell(1,vesorus[0],1,Vector2i(35,3))
	#
	
		prerender()
		#sembunyikan action option
		actionoption.visible = false
	#inisialisasi astar_grid
		astar_grid.size = tile_set.mapSize # setting ukuran peta
		astar_grid.cell_size = tile_set.cellSize # setting ukuran kolom
		astar_grid.offset = tile_set.cellSize/2 # setting offset astar_grid
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
				$battle_manager.mechAction[child] = [1,1,1] # set mechAction in battle manager 
	#

func _input(event):
	#ketika script berjalan didalam game
	if not Engine.is_editor_hint():
		#	#jika input(event) adalah sebuah tombol mouse
		if event is InputEventMouseButton:
			if event.is_action_pressed("left-click"):
				if !_helper_hover and !_helpper_is_play:
					lets_select_unit()
				#tambahan kondisi tombol diatas
		if event is InputEventMouseMotion:
			if astar_grid.is_in_boundsv(local_to_map(event.position-position)):
				gridder = local_to_map(event.position-position)
				if _helper_selected_action == "move" and _is_action_selected:
					prerender()
				$Pergerakan.posisikan_indikator(map_to_local(gridder))
				
	#jika input(event) adalah sebuah tombol keyboard
		if event is InputEventKey:
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
				if !_helper_hover and !_helpper_is_play:
					lets_select_unit()
				highlight()
	#
	
	#refresh ulang tampilan
			#prerender()
	#
func lets_select_unit():
	
	if robots.has(gridder):
		pass
		actionoption.position = map_to_local(gridder)+Vector2(32,0)
		actionoption.visible = true
		$Pergerakan.target_yang_dipindahkan = robots[gridder]
		_temp_action_point = $battle_manager.mechAction[robots[gridder]]
		action_option_move.visible = false if _temp_action_point[0] == 0 else true
		action_option_attack.visible = false if _temp_action_point[1] == 0 else true
		action_option_skill.visible = false if _temp_action_point[2] == 0 else true
		if $Pergerakan.target_yang_dipindahkan != null:
				start = gridder
	else :
		
		if !_is_action_selected : # akan tereksekusi saat memilih set saat menu terlihat 
			actionoption.visible = false
		if _is_action_selected and _helper_selected_action == "move" :
			move_unit()
	if _is_action_selected:
		_helper_selected_action = ""

func move_unit():
	if packedpoints.size() > 1: #cek apakah pergerakan lebih dari 1
		$Pergerakan.initpath() #robot akan bergerak
		_helpper_is_play = true
		robots.erase(start) #robot akan dihapus dari array  
		astar_grid.set_point_solid(start,false)
			#popup action option =====================
		actionoption.visible = false
		_is_action_selected = false
		actionoption.visible = false

#alur =
#-jika lebih dari 1 akan menggambar
func prerender():
		if _is_action_selected:
			if astar_grid.is_in_boundsv(gridder):
				packedpoints = astar_grid.get_point_path(start, gridder)
				$Pergerakan.repath(packedpoints)
				

#ketika selesai bergerak ->
func _on_pergerakan_move_finished(last_robot : Node2D):
	robots[local_to_map(last_robot.position)] = last_robot #lokasi terakhir robot akan ditambahkan ke array
	astar_grid.set_point_solid(local_to_map(last_robot.position))
	if _helper_selected_action == "move" :
		_temp_action_point[0] = 0
		managed_action.emit(last_robot,_temp_action_point)
	elif _helper_selected_action == "attack" :
		_temp_action_point[1] = 0
		managed_action.emit(last_robot,_temp_action_point)
	elif _helper_selected_action == "skill" :
		_temp_action_point[2] = 0
		managed_action.emit(last_robot,_temp_action_point)
	_helpper_is_play = false # bisa coba ganti sendiri , cuma mencegah select ketika sedang execut robot
	_helper_selected_action = ""
	

func _on_actionoption_selected_action(value):
	if actionoption.is_visible_in_tree():
		_is_action_selected = true
	if value == "move" :
		_helper_selected_action = "move"
	elif value == "attack" :
		pass
		_helper_selected_action = "attack"
	elif value == "skill" :
		pass
		_helper_selected_action = "skill"
		

func _on_actionoption_mouse_entered_each_option(condition):
	_helper_hover = condition


func _on_button_end_turn_button_down():
	
	for child in find_children("*","Sprite2D"):
			if child.is_in_group("robot"):
				$battle_manager.mechAction[child] = [1,1,1]
	
