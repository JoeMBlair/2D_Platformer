extends Node2D

export(NodePath) var level_name = "world_1/level_test/level_test"
export(NodePath) var node_path
var fps
var level_instance
signal level_xy
var tiles = {"Enemies": ["goomba", "bullet_bill"],
			"Items": ["mushroom", "coin"],
			"Blocks": ["block_question_mark", "block_brick_top"],
			"Objects": ["Player"]}


func _ready():
	load_level()
	
	
func _process(_delta):
	
	if Input.is_action_just_pressed("reset"):
		pass
		get_tree().reload_current_scene()
#		add_objects(level_instance.get_node("Objects"))
	Debug.display_info("Main", {"FPS": Engine.get_frames_per_second()})
		
func add_objects(tilemap : TileMap):
	var objects = get_objects.object_paths
	var tile_id_array  = tilemap.get_used_cells()
	# Checks each tile and if it matches loads in the associated node.
	for tile_id in tile_id_array.size():
		var tile_id_vector = tilemap.get_cellv(tile_id_array[tile_id])
		var tile_name = tilemap.tile_set.tile_get_name(tile_id_vector)
		var object = get_objects.object_paths
#		print(tilemap_tile_name)
		
		if objects.has(tile_name):
			var filename = objects[tile_name]
			var object_instance = load(filename).instance()
			add_child(object_instance)
			var position = tilemap.map_to_world(tile_id_array[tile_id] * 4)
			
			position.x += 32
			position.y += 32
			object_instance.position = position
			
			tilemap.set_cellv(tile_id_array[tile_id], -1)


func load_level():
#	var filename = "res://Levels/" + level_name + ".tscn"
	var filename
	filename = "res://Levels/world_1/level_test/Level_Test.tscn"
	level_instance = load(filename).instance()
	add_child(level_instance)
	level_instance.position = Vector2(0, 0)
	
	add_objects(level_instance.get_node("Enemies"))
	add_objects(level_instance.get_node("Blocks"))
	add_objects(level_instance.get_node("Items"))
	add_objects(level_instance.get_node("Objects"))
	
#	emit_signal("level_xy", get_node("res://Objects/").get_used_rect())

