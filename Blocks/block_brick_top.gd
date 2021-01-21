extends Node2D


func _ready():
	pass
	
func _process(delta):
	if $block.health == 0:
		queue_free()
	pass
	

func _on_block_hit(powerup):
	if powerup	!= "small":
		$block.health -= 1
