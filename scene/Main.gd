extends Node2D

export(NodePath) var level_name = "world_1/level_test/level_test"
export(NodePath) var node_path
var fps
var level_instance
signal level_xy

func _ready():
	load_level("res://Levels/world_1/level_Test/Level_Test.tscn")
	
	
	
func _process(_delta):
	
	if Input.is_action_just_pressed("reset"):
		pass
#		get_tree().reload_current_scene()
		load_level("res://Levels/world_1/level_test/Level_Test.tscn")
#		add_objects(level_instance.get_node("Objects"))
	Debug.display_info("Main", {"FPS": Engine.get_frames_per_second()})
	
	
		
func add_objects(tilemap : TileMap):
	var objects = get_objects.object_paths
	var tile_id_array  = tilemap.get_used_cells()
	# Checks each tile and if it matches loads in the associated node.
	for tile_id in tile_id_array.size():
		var tile_id_vector = tilemap.get_cellv(tile_id_array[tile_id])
		var tile_name = tilemap.tile_set.tile_get_name(tile_id_vector)
		
		if objects.has(tile_name):
			var filename = objects[tile_name]
			print(filename)
			var object_instance = load(filename).instance()
			$Objects.add_child(object_instance)
			var position = tilemap.map_to_world(tile_id_array[tile_id] * 4)
			
			position.x += 32
			position.y += 32
			object_instance.position = position
			
			tilemap.set_cellv(tile_id_array[tile_id], -1)


func load_level(filename):
	clear_level(filename)
	
	if level_instance == null:
		level_instance = load(filename).instance()
		add_child(level_instance)
		level_instance.position = Vector2(0, 0)
		var level_bounds = level_instance.get_node("Blocks").get_used_rect()
		
		var tiles = get_tree().get_nodes_in_group("GameTiles")
		print("tiles")
		add_objects(level_instance.get_node("Enemies"))
		add_objects(level_instance.get_node("Blocks"))
		add_objects(level_instance.get_node("Items"))
		add_objects(level_instance.get_node("Objects"))
		
		for tile in tiles:
			tile.queue_free()
		
		set_camera(level_bounds)


func set_camera(bounds):
		var player = get_node("Objects/Player")
		var camera = Camera2D.new()
		player.add_child(camera)
		camera.current = true
		camera.limit_left = bounds.position.x * 64
		camera.limit_top = bounds.position.y * 64
		camera.limit_right = bounds.size.x * 64
		camera.limit_bottom = (bounds.position.y + bounds.size.y) * 64
		
func clear_level(filename):
	if level_instance != null:
		level_instance.queue_free()
		var nodes = $Objects.get_children()
		for node in nodes:
			node.queue_free()
