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
	pass
			
func check_health(item):
	if $block.health == 0:
		if item != "none":
			$block/AnimatedSprite.animation = "hit"
		else:
			$AnimationPlayer.play("break")
			$block.visible = false
			yield(get_tree().create_timer(0.5), "timeout")
			$block.queue_free()
			yield(get_node("AnimationPlayer"), "animation_finished")
			queue_free()


func _on_block_hit_response(powerup, item):
	if item != "none":
		$block.health -= 1
	elif powerup != "small":
		$block.health -= 1
	check_health(item)
