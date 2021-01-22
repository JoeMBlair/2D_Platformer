extends Node2D

class_name State

var change_state
var sprite
var persistant_state
var velocity = 0

func _physics_process(_delta):
	persistent_state.move_and_slide(persistent_state.velocity, Vector2.UP)
	
func setup(change_state, sprite, persistant_state):
	self.change_state = change_state
	self.sprite = sprite
	self.persistant_state = persistant_state
	
func move_left():
	pass
	
func move_right():
	pass
