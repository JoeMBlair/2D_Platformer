extends KinematicBody2D

var object_name = "mushroom"
var item_name = "mushroom"
var velocity : Vector2
export var speed : int = 50
var direction : String = "right"
var gravity = Global.gravity
export var state : String = "spawning"

func _ready():
	pass

func debug():
	var data = {"POS": self.position,
				"state": state,
				"direction": direction,
				"velocity": velocity}
	Debug.display_info(self.name, data)

func spawn_item():
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("spawn")


func _process(delta):
	debug()
	velocity.x = 0
	if state == "move":
		velocity.y += gravity * delta		
#		$Area2D/CollisionShape2D2.set_deferred("disabled", true)
		if direction == "left":
			velocity.x -= speed
		else:
			velocity.x += speed
				
		

func _physics_process(delta):
	# Gravity
	
		
	# Applying the velocity
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "spawn":
		state = "move"
		$CollisionShape2D.set_deferred("disabled", false)
		$DetectorLeft/CollisionShape2D.set_deferred("disabled", false)
		$DetectorRight/CollisionShape2D.set_deferred("disabled", false)


func _on_DetectorLeft_body_entered(_body):
	direction = "right"
	$DetectorLeft/CollisionShape2D.set_deferred("disabled", true)
	$DetectorRight/CollisionShape2D.set_deferred("disabled", false)


func _on_DetectorRight_body_entered(_body):
	direction = "left"
	$DetectorRight/CollisionShape2D.set_deferred("disabled", true)
	$DetectorLeft/CollisionShape2D.set_deferred("disabled", false)
