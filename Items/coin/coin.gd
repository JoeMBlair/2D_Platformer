extends StaticBody2D

var object_name = "coin"
var item_name = "coin"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# ntCalled every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func spawn_item():
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("spawn")
	pass


func object_collision():
	queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "spawn":
		self.queue_free()
		world_properties.score += 100
