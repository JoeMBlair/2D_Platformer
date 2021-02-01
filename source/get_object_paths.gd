extends Node

var object_paths : Dictionary

func _ready():
	var groups = get_children()
	for group in groups:
		var objects = group.get_children()
		
		for object in objects:
			object_paths[object.object_name] = object.filename
			object.queue_free()
	print(object_paths)
