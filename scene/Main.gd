extends Node2D

export(NodePath) var level_name = "world_1/level_test/level_test"
export(NodePath) var node_path
var fps
var level_instance
signal level_xy

func _ready():
	pass
	set_camera($LoadLevel.level_bounds)


func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		pass
	Debug.display_info("Main", {"FPS": Engine.get_frames_per_second()})


func _on_LoadLevel_loaded(level_bounds):
	set_camera(level_bounds)


func set_camera(bounds):
		var player = get_node("LoadLevel/Objects/Player")
		var camera = Camera2D.new()
		camera.name = "Camera2D"
		player.add_child(camera)
		camera.current = true
		camera.limit_left = bounds.position.x * 64
		camera.limit_top = bounds.position.y * 64
		camera.limit_right = bounds.size.x * 64
		camera.limit_bottom = (bounds.position.y + bounds.size.y) * 64

