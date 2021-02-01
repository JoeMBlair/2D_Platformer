extends KinematicBody2D

var speed := 500
var gravity := world_properties.gravity
var velocity := Vector2.ZERO
var player 



func _ready():
	pass
	
func _process(delta):
	if player:
		var distance_to_player = self.get_global_position() - player.get_global_position()
		if abs(distance_to_player.x) > 110:
			if distance_to_player.x > 100:
				velocity.x = -200
				$AnimatedSprite.flip_h = true
			elif distance_to_player.x < 100:
				velocity.x = 200
				$AnimatedSprite.flip_h = false		
			else:
				velocity.x = 0
		if abs(velocity.x) <  20:
			$AnimatedSprite.animation = "idle"
		else:
			$AnimatedSprite.animation = "walk"
			
			
	pass
	
func _physics_process(delta):
	velocity.y = gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		player = body
	pass # Replace with function body.
