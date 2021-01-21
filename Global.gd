extends Node

export var gravity : int = 3200
export var score : int = 0
var level_size

# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Debug.display_info("Debug", {"Score": score})
