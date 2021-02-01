extends StaticBody2D

var object_name = "coin"
var item_name = "coin"
var current_animation
var spawn = false
var count = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
#	$AnimationPlayer.play("spawn")
	
func spawn_item():
	$CollisionShape2D.set_deferred("disabled", true)
#	yield(self, "tree_entered")
	$AnimationPlayer.play("spawn")
	Debug.display_info(self.name, {"1": $AnimationPlayer.current_animation})
	print($AnimationPlayer.current_animation)
	
	spawn = true
	pass


# ntCalled every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if spawn:
		Debug.display_info(self.name, {self.name: $AnimationPlayer.current_animation})
	pass




func object_collision():
	queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "spawn":
		self.queue_free()
		world_properties.score += 100
