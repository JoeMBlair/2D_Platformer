extends Node2D

var tiles
var tile_paths : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	tiles = get_tree().get_nodes_in_group("Tile")
	for node in tiles:
		tile_paths[node.object_name] = node.filename
		node.queue_free()
	print(tile_paths)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
