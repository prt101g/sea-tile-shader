extends YSort

enum MapSize {
	TINY = 0,
	SMALL,
	MEDIUM,
	LARGE,
	HUGE,
}

enum TileType {
	TILE_EMPTY = -1,
	TILE_OCEAN,
	TILE_SEA,
	TILE_LAND,
}

enum SurfaceType {
	TILE_EMPTY = -1,
	TILE_GRASS,
	TILE_SNOW,
	TILE_DESERT,
	TILE_FOREST,
	TILE_SNOW_FOREST,
	TILE_OASIS,
	TILE_HILL,
	TILE_SNOW_HILL,
	TILE_DESERT_HILL,
	TILE_MOUNTAIN,
}

enum MapTileType {
	TILE_EMPTY = -1,
	TILE_OCEAN,
	TILE_SEA,
	TILE_GRASS,
	TILE_FOREST,
	TILE_HILL,
	TILE_SNOW,
	TILE_SNOW_FOREST,
	TILE_SNOW_HILL,
	TILE_DESERT,
	TILE_OASIS,
	TILE_DESERT_HILL,
	TILE_MOUNTAIN,
}

const MAP_LAYER_GROUP = "MAP_LAYER"

var bounding_rect : Rect2
var map_size : Vector2


func init(map_data : Dictionary) -> void:
	_reset_map()
	map_size = Vector2(map_data.tile_data.size(), map_data.tile_data[0].size())
	_draw_tiles(map_data.tile_data)
	bounding_rect = _calculate_bounding_rect($Tile)


func _reset_map() -> void:
	$Tile.clear()
	$Surface.clear()


func _draw_tiles(map_tile_data : Array) -> void:
	var x = 0
	for tile_row in map_tile_data:
		var y = 0
		for tile_type in tile_row:
			if tile_type == MapTileType.TILE_EMPTY:
				set_tile(x, y, MapTileType.TILE_EMPTY)
			else:
				set_tile(x, y, tile_type)
			y += 1
		x += 1


func _calculate_bounding_rect(tilemap) -> Rect2:
	var cell_bounds = tilemap.get_used_rect()
	var horizontal_scale = tilemap.cell_size.x * tilemap.scale.x

	# Calculate the bounding rectangle in world coords
	var cell_to_pixel = Transform2D(
			Vector2(horizontal_scale, 0),
			Vector2(0, tilemap.cell_size.y * tilemap.scale.y),
			Vector2())

	var bound_position = cell_to_pixel * cell_bounds.position
	bound_position.x -= (horizontal_scale * cell_bounds.size.x) / 2
	return Rect2(bound_position, cell_to_pixel * cell_bounds.size)


func get_tile(tile_position : Vector2) -> int:
	return $Tile.get_cellv(tile_position)


func set_tile(x, y, tile_type) -> void:
	$Tile.set_cell(x, y, _get_tile(tile_type))
	$Surface.set_cell(x, y, _get_surface(tile_type))


func set_tile_at(tile_position : Vector2, tile_type) -> void:
	set_tile(tile_position.x, tile_position.y, tile_type)


func _get_tile(tile_type : int) -> int:
	var result

	match int(tile_type):
		MapTileType.TILE_OCEAN:
			result = TileType.TILE_OCEAN
		MapTileType.TILE_SEA:
			result = TileType.TILE_SEA
		MapTileType.TILE_EMPTY:
			result = TileType.TILE_EMPTY
		_:
			result = TileType.TILE_LAND

	return result


func _get_surface(tile_type) -> int:
	var result

	match int(tile_type):
		MapTileType.TILE_GRASS:
			result = SurfaceType.TILE_GRASS
		MapTileType.TILE_SNOW:
			result = SurfaceType.TILE_SNOW
		MapTileType.TILE_DESERT:
			result = SurfaceType.TILE_DESERT
		MapTileType.TILE_FOREST:
			result = SurfaceType.TILE_FOREST
		MapTileType.TILE_SNOW_FOREST:
			result = SurfaceType.TILE_SNOW_FOREST
		MapTileType.TILE_OASIS:
			result = SurfaceType.TILE_OASIS
		MapTileType.TILE_HILL:
			result = SurfaceType.TILE_HILL
		MapTileType.TILE_SNOW_HILL:
			result = SurfaceType.TILE_SNOW_HILL
		MapTileType.TILE_DESERT_HILL:
			result = SurfaceType.TILE_DESERT_HILL
		MapTileType.TILE_MOUNTAIN:
			result = SurfaceType.TILE_MOUNTAIN
		_:
			result = SurfaceType.TILE_EMPTY

	return result


func get_surface(tile_position : Vector2) -> int:
	return $Surface.get_cellv(tile_position)


func set_surface(tile_position : Vector2, value : int) -> void:
	$Surface.set_cellv(tile_position, value)


func convert_to_map_tile_type(x : int, y : int) -> int:
	var result : int

	match int($Tile.get_cell(x, y)):
		TileType.TILE_OCEAN:
			result = MapTileType.TILE_OCEAN
		TileType.TILE_SEA:
			result = MapTileType.TILE_SEA
		TileType.TILE_LAND:
			match int($Surface.get_cell(x, y)):
				SurfaceType.TILE_GRASS:
					result = MapTileType.TILE_GRASS
				SurfaceType.TILE_SNOW:
					result = MapTileType.TILE_SNOW
				SurfaceType.TILE_DESERT:
					result = MapTileType.TILE_DESERT
				SurfaceType.TILE_FOREST:
					result = MapTileType.TILE_FOREST
				SurfaceType.TILE_SNOW_FOREST:
					result = MapTileType.TILE_SNOW_FOREST
				SurfaceType.TILE_OASIS:
					result = MapTileType.TILE_OASIS
				SurfaceType.TILE_HILL:
					result = MapTileType.TILE_HILL
				SurfaceType.TILE_SNOW_HILL:
					result = MapTileType.TILE_SNOW_HILL
				SurfaceType.TILE_DESERT_HILL:
					result = MapTileType.TILE_DESERT_HILL
				SurfaceType.TILE_MOUNTAIN:
					result = MapTileType.TILE_MOUNTAIN
				_:
					result = TileType.TILE_EMPTY
		_:
			result = MapTileType.TILE_EMPTY

	return result
