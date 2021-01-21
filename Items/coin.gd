extends Area2D

var item_name = "coin"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_item():
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("spawn")
	pass

func _on_Coin_body_entered(body):
	if body.is_in_group("Player"):
		self.queue_free()
		pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "spawn":
		self.queue_free()
		Global.score += 100
