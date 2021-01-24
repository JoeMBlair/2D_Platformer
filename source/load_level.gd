extends Node2D

var level_instance
var level_bounds
export var level_filename : String = "res://levels/world_1/level_test/level_test.tscn"
signal loaded(level_bounds)

func _ready():	
	load_level(level_filename)


func _process(delta):
	if Input.is_action_just_pressed("reset"):
		load_level("res://levels/world_1/level_test/level_test.tscn")


func load_level(filename):
	clear_level()
	
	if level_instance == null:
		level_instance = load(filename).instance()
		add_child(level_instance)
		level_instance.position = Vector2(0, 0)
		level_bounds = level_instance.get_node("Blocks").get_used_rect()
		var tilemaps = get_tree().get_nodes_in_group("GameTiles")
		
		
		for tilemap in tilemaps:
			add_objects(tilemap)
		emit_signal("loaded", level_bounds)

func add_objects(tilemap : TileMap):
	var objects = get_objects.object_paths
	var tile_ids  = tilemap.get_used_cells()
	# Checks each tile and if it matches loads in the associated node.
	for tile_id in tile_ids.size():
		var tile_id_vector = tilemap.get_cellv(tile_ids[tile_id])
		var tile_name = tilemap.tile_set.tile_get_name(tile_id_vector)
		
		if objects.has(tile_name):
			var filename = objects[tile_name]
			var object_instance = load(filename).instance()
			$Objects.add_child(object_instance)
			var position = tilemap.map_to_world(tile_ids[tile_id] * 4)
			position.x += 32
			position.y += 32
			object_instance.position = position
			tilemap.set_cellv(tile_ids[tile_id], -1)


func clear_level():
	if level_instance != null:
		level_instance.queue_free()
		var nodes = $Objects.get_children()
		for node in nodes:
			node.queue_free()
