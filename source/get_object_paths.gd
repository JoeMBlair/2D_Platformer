extends Node

var objects
var object_paths : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	objects = get_tree().get_nodes_in_group("Object")
	for object in objects:
		object_paths[object.object_name] = object.filename
		object.queue_free()
	print(object_paths)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
