extends CollisionShape2D

var current_state


func _ready():
	pass # Replace with function body.

func _process(delta):
	var bodies = $DetectorHead.get_overlapping_areas()
	for i in bodies:
		print(i)
		if i.is_in_group("Block") and current_state == "jump":
			i.get_parent().block_hit("small")
		


func _on_Player_current_state(state):
	current_state = state

func _on_DetectorHead_area_entered(area):
#	if area.is_in_group("Block") and current_state == "jump":
#		area.get_parent().block_hit("small")
	pass



