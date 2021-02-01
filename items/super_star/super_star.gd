extends StaticBody2D

var object_name := "super_star"
var item_name := "super_star"

func _ready():
	pass
	
func spawn_item():
	$AnimationPlayer.play("spawn")
	pass


func _on_DetectorItem_body_entered(body):
	if body.is_in_group("Player"):
		body.powerup_states["super_star"].previous_state = body.state_powerup
		if body.state_powerup == "fire_flower":
			body.powerup_states["super_star"].colours = body.powerup_states["fire_flower"].colours
		body.powerup("super_star")
		
		queue_free()
	pass # Replace with function body.
