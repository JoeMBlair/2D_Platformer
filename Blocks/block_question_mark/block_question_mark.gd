extends Node2D

var object_name = "block_question_mark"

func _ready():
	pass

func _process(_delta):
	pass

func _on_block_hit_response(_powerup):
#	print(powerup)
	$block/AnimatedSprite.animation = "hit"
	$block.health = 0
