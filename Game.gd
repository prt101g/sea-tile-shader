extends Node

const MapTileType = preload("res://Map.gd").MapTileType

var viewport_size : Vector2
var tile_data = {
		"spawn_points" : [],
		"resource_data" : {},
		"building_data" : {},
		"tile_data" : [
			[
				MapTileType.TILE_DESERT,
				MapTileType.TILE_SEA,
				MapTileType.TILE_OCEAN,
			],
			[
				MapTileType.TILE_DESERT,
				MapTileType.TILE_SEA,
				MapTileType.TILE_OCEAN,
			],
			[
				MapTileType.TILE_DESERT,
				MapTileType.TILE_SEA,
				MapTileType.TILE_OCEAN,
			]
		]
	}


func _ready() -> void:
	viewport_size = get_viewport().size

	# Create and initialize map
	$Map.init(tile_data)

	# Initialize camera
	$Camera.set_limit_rect($Map.bounding_rect)
