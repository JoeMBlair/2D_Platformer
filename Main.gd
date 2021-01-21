extends Node2D

export var level_name = "Level_1"
var fps
signal level_xy
var tiles = {"Enemies": ["goomba", "bullet_bill"],
			"Items": ["mushroom", "coin"],
			"Blocks": ["block_question_mark", "block_brick_top"],
			"Objects": ["Player"]}


func _ready():
	load_level()
	
	
func _process(delta):
	
	if Input.is_action_just_pressed("reset"):
		pass
		get_tree().reload_current_scene()
#		add_objects(level_instance.get_node("Objects"))
	Debug.display_info("Main", {"FPS": Engine.get_frames_per_second()})
		
func add_objects(tilemap : TileMap):
	
	# Loads TileMaps for the level
	if tiles.has(tilemap.name):
#		Debug.display_info("Main", {"Tilemap Name": tilemap.name})
		var tile_id_array  = tilemap.get_used_cells()
		
		# Checks each tile and if it matches loads in the associated node.
		for tile_id in tile_id_array.size():
			var tile_id_vector = tilemap.get_cellv(tile_id_array[tile_id])
			var tile_name = tilemap.tile_set.tile_get_name(tile_id_vector)
	#		
			if tiles[tilemap.name].has(tile_name):
				var filename = "res://" + tilemap.name + "/" + tile_name + ".tscn"
				var object_instance = load(filename).instance()
				add_child(object_instance)
				var position = tilemap.map_to_world(tile_id_array[tile_id] * 4)
				
				position.x += 32
				position.y += 32
				object_instance.position = position
				
				tilemap.set_cellv(tile_id_array[tile_id], -1)


func load_level():
	var filename = "res://Levels/" + level_name + ".tscn"
	var level_instance = load(filename).instance()
	add_child(level_instance)
	level_instance.position = Vector2(0, 0)
#	level_instance.set_name("Level_layout")
	
	add_objects(level_instance.get_node("Enemies"))
	add_objects(level_instance.get_node("Blocks"))
	add_objects(level_instance.get_node("Items"))
	add_objects(level_instance.get_node("Objects"))
	
#	emit_signal("level_xy", get_node("res://Objects/").get_used_rect())

