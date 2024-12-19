extends TileMapLayer
class_name TileGrid

func recenter_tilegrid(media_size: Vector2):
	var bhops = ((get_used_cells().max()+Vector2i(1,1))*tile_set.tile_size)/2
	position= (media_size/2)-Vector2(bhops)

func build_tilemap(tilegrid_prop: TileGridBuilder.TGprop):
	clear()
	for i in tilegrid_prop.tilepack:
		var index= randi() % tilegrid_prop.atlas_range.size()
		var HLP= tilegrid_prop
		set_cell(i, HLP.IDTile, HLP.atlas_range[index], 0)
	recenter_tilegrid(Control_Core.get_media_size())

func align_position(global_position: Vector2):
	var gridded= local_to_map(global_position-position)
	return map_to_local(gridded)+position

func is_in_here(global_position: Vector2):
	var gridded= local_to_map(global_position-position)
	return get_used_cells().has(gridded)

func change_position(asigned_position: Vector2):
	position= asigned_position
