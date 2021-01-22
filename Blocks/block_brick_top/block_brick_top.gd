extends Node2D

var object_name = "block_brick_top"

func _ready():
	pass
	
func _process(_delta):
	if $block.health == 0:
		queue_free()
	pass
	

func _on_block_hit(powerup):
	if powerup	!= "small":
		$block.health -= 1
