extends Node2D

var object_name = "block_question_mark"

func _ready():
	pass

func _process(delta):
	pass

func _on_block_hit_response(powerup):
	print(powerup)
	$block/AnimatedSprite.animation = "hit"
	$block.health = 0
