extends Node2D
var levels = [ 
			"res://levels/world_1/level_test/level_test.tscn",
			"res://levels/world_1/level_1_1/level_1_1.tscn"
			]
export (String, 
		"res://levels/world_1/level_test/level_test.tscn",
		"res://levels/world_1/level_1_1/level_1_1.tscn"
		) var level_name 
export(NodePath) var node_path
var fps
var level_instance
var level_select := false
var debug_select := false
var camera
var player

func _ready():
	pass
#	set_camera($LoadLevel.level_bounds)


func _process(_delta):
	Debug.display_info("Main", {"Level Select": level_select, "Debug Select": debug_select})
	if Input.is_action_just_pressed("reset"):
		level_select = not level_select
	if Input.is_action_just_pressed("debug"):
		debug_select = not debug_select
		
	if level_select:
		if Input.is_action_just_pressed("num_1"):
			$LoadLevel.load_level(levels[0])
			level_select = false
		if Input.is_action_just_pressed("num_2"):
			$LoadLevel.load_level(levels[1])
			level_select = false
		if Input.is_action_just_pressed("num_3"):
#			$LoadLevel.load_level(levels[2])
			level_select = false
			
	if debug_select:
		if Input.is_action_just_pressed("num_1"):
			player.powerup("mushroom")
			debug_select = false
		if Input.is_action_just_pressed("num_2"):
			player.powerup("small")
			debug_select = false
		if Input.is_action_just_pressed("num_3"):
			player.powerup("fire_flower")
			debug_select = false
		if Input.is_action_just_pressed("num_4"):
			player.powerup_states["super_star"].previous_state = player.state_powerup
			player.powerup("super_star")
			debug_select = false
	Debug.display_info("Main", {"FPS": Engine.get_frames_per_second()})


func _on_LoadLevel_loaded(bounds, local_player):
	player = local_player
	camera = Camera2D.new()
	camera.name = "Camera2D"
	player.add_child(camera)
	camera.current = true
	camera.limit_left = bounds.position.x * 64
	camera.limit_top = bounds.position.y * 64
	camera.limit_right = bounds.size.x * 64
	camera.limit_bottom = (bounds.position.y + bounds.size.y) * 64
