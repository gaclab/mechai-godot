extends TileMapLayer
class_name TileMaps

var grid_size:Vector2i
var astar : AStarGrid2D
func _init(grid_size) -> void:
	tile_set = load("res://Assets/Tres/tileset_default.tres")
	self.grid_size = grid_size
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			self.set_cell(Vector2i(x,y),1,Vector2i(0,0),0)
			#print('phe')
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
