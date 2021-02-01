extends Node2D


var level_instance
var level_bounds
export var level_filename : String = "res://levels/world_1/level_1_1/level_1_1.tscn"
signal loaded(level_bounds, player)
var item_array = []
var block_array = []
var player
onready var pause_group = get_node("Objects").get_tree()

func _ready():	
	load_level(level_filename)
	pass
	

func _process(_delta):
	if world_properties.pause_game and not pause_group.paused:
		pause_group.paused = true
		pass
	elif not world_properties.pause_game and pause_group.paused:
		pause_group.paused = false
#		print(pause_group.paused)
		
		
#	if Input.is_action_just_pressed("reset"):
#		load_level("res://levels/world_1/level_1_1/level_1_1.tscn")
	pass

func load_level(filename):
	clear_level()
	
#	if level_instance == null:
	level_instance = load(filename).instance()
	add_child(level_instance)
	level_instance.position = Vector2(0, 0)
	level_bounds = level_instance.get_node("Blocks").get_used_rect()
	var tilemaps = get_tree().get_nodes_in_group("GameTiles")
	
	for tilemap in tilemaps:
		add_objects(tilemap)
	emit_signal("loaded", level_bounds, player)
	
#	#If item is overlapping block then load that item into block
	for item in item_array.size():
		for block in block_array.size():
			if block_array[block].position == item_array[item].position:
				block_array[block].get_node("block").held_item = item_array[item].item_name
				item_array[item].queue_free()

func add_objects(tilemap : TileMap):
	var objects = get_objects.object_paths
	var tile_ids  = tilemap.get_used_cells()
	# Checks each tile and if it matches loads in the associated node.
	for tile_id in tile_ids.size():
		var tile_id_vector = tilemap.get_cellv(tile_ids[tile_id])
		
		if not tile_id_vector == -1:
			var tile_name = tilemap.tile_set.tile_get_name(tile_id_vector)
			
			if objects.has(tile_name):
				var object_instance

				var filename = objects[tile_name]
				object_instance = load(filename).instance()
				$Objects.add_child(object_instance)
				
				var position = tilemap.map_to_world(tile_ids[tile_id] * 4)
				position += Vector2(32, 32)
				object_instance.position = position
				if object_instance.object_name == "player_new":
					player = object_instance 
				if object_instance.is_in_group("Item"):
					item_array.append(object_instance)
				elif object_instance.is_in_group("Block"):
					block_array.append(object_instance)
					
				tilemap.set_cellv(tile_ids[tile_id], -1)


func clear_level():
	if level_instance != null:
		level_instance.queue_free()
		block_array.clear()
		item_array.clear()
		var nodes = $Objects.get_children()
		for node in nodes:
			node.queue_free()


func _on_Player_pause_game():
	pass # Replace with function body.
