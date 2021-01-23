extends Node2D

var object_name = "block_hidden"
func _ready():
	$block/CollisionShape2D.set_deferred("disabled", true)
	pass


func _on_block_block_hit_response(_powerup):
	$block/CollisionShape2D.set_deferred("disabled", false)
	$block/AnimatedSprite.animation = "hit"
	$block.health = 0
