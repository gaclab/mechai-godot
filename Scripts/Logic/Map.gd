extends TileMap
var gridder = Vector2(0,0)
@onready var zona_arena : Array[Vector2i] = get_used_cells(0)
var points : Curve2D
var selected = false

func _ready():
	$Pergerakan.posisikan_indikator(map_to_local(Vector2(0,0)))

func _input(event):
	if event.is_action_pressed("ui_up"):
		$Pergerakan.pindah_indikator(Vector2.UP*tile_set.tile_size.x)
	if event.is_action_pressed("ui_right"):
		$Pergerakan.pindah_indikator(Vector2.RIGHT*tile_set.tile_size.x)
	if event.is_action_pressed("ui_left"):
		$Pergerakan.pindah_indikator(Vector2.LEFT*tile_set.tile_size.x)
	if event.is_action_pressed("ui_down"):
		$Pergerakan.pindah_indikator(Vector2.DOWN*tile_set.tile_size.x)
	if event.is_action_pressed("ui_home"):
		$Pergerakan.sedang_menggambar = !$Pergerakan.sedang_menggambar
		$Pergerakan.tambahkan_titk_jejak()

"""
	if Vector2i(gridder) in zona_arena:
		$Indicator.position = map_to_local(gridder)
	else:
		gridder = Vector2(local_to_map($Indicator.position))
"""
