extends TileMap

var tiles
var tile_paths : Dictionary
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	tiles = get_tree().get_nodes_in_group("Block")
	for nodes in tiles:
		tile_paths[nodes.object_name] = nodes.get_path()
		print(tile_paths)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass