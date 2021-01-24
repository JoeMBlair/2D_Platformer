extends Node2D

var object_name = "block_brick_top"

func _ready():
	pass
	
func _process(_delta):
	pass
			
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
