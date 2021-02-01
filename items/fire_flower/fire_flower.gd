extends StaticBody2D

var object_name := "fire_flower"
var item_name := "fire_flower"

func _ready():
	pass
	
func spawn_item():
	$AnimationPlayer.play("spawn")
	pass


func _on_DetectorItem_body_entered(body):
	if body.is_in_group("Player"):
		body.powerup("fire_flower")
		queue_free()
	pass # Replace with function body.
