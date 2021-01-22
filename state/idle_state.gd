extends State

class_name IdleState

func _ready():
	sprite.play("idle")
	
func _flip_direction():
	sprite.flip_h = not sprite.flip_h
	
func move_left()

func move_right()
