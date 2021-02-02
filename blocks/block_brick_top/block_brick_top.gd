extends Node2D

var object_name = "block_brick_top"
onready var block_tl = get_node("block_tl")
onready var block_tr = get_node("block_tr")
onready var block_bl = get_node("block_bl")
onready var block_br = get_node("block_br")
onready var l = {
				"start_pos": block_tl.position, 
				"mid_pos": (block_tl.position - Vector2(-32, -128)),
				"end_pos": (block_tl.position - Vector2(-64, -32)),
				}
onready var r = {
				"start_pos": block_tl.position, 
				"mid_pos": (block_tl.position - Vector2(32, 128)),
				"end_pos": (block_tl.position - Vector2(64, 32)),
				}
var time = 0.0
func _ready():
	pass
	
func _process(_delta):
	pass
	
func _physics_process(delta):
	block_tl.position = _quadratic_bezier(l.start_pos, l.mid_pos, l.end_pos, time)
	block_tr.position = _quadratic_bezier(r.start_pos, r.mid_pos, r.end_pos, time)
	block_bl.position = _quadratic_bezier(l.start_pos, l.mid_pos, l.end_pos, time)
	block_br.position = _quadratic_bezier(r.start_pos, r.mid_pos, r.end_pos, time)
	if time < 1:
		time += 2 * delta

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.linear_interpolate(p1, t)
	var q1 = p1.linear_interpolate(p2, t)
	
	var rt = q0.linear_interpolate(q1, t)
	return rt
			
func check_health(item):
	if $block.health == 0:
		if item != "none":
			$block/AnimatedSprite.animation = "hit"
		else:
			queue_free()


func _on_block_hit_response(powerup, item):
	if item != "none":
		$block.health -= 1
	elif powerup != "small":
		$block.health -= 1
	check_health(item)
