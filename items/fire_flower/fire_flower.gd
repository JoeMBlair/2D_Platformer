extends StaticBody2D

var object_name := "fire_flower"
var item_name := "fire_flower"

func _ready():
	pass
	
func spawn_item():
	$AnimationPlayer.play("spawn")
	pass
