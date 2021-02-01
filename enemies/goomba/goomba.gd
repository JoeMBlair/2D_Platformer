extends KinematicBody2D

var object_name = "goomba"
export var direction = "right"
var state = "alive"
var powerup = ""

# Physics
export var speed : int = 50
export var jumpForce : int = 600
var bounce_force = 300
var paused = false
#var gravity : int = Global.gravity
var gravity : int = world_properties.gravity

var velocity : Vector2 = Vector2()
var grounded : bool = false

# Components
onready var sprite = $Sprite
onready var detector_left = $Detector/Left/CollisionShape2D
onready var detector_right = $Detector/Right/CollisionShape2D

func debug():
	var debug_array = {"Direction": direction, "Velocity": velocity, "bit": $DetectorHead.get_collision_layer_bit(3)}
	Debug.display_info("Goomba", debug_array)


func _ready(): 
	pass


func _physics_process(delta):
#	debug()
	# Reset horizontal velocity
	velocity.x = 0
	
	# Movement inputs
	if state == "alive" and $VisibilityNotifier2D.is_on_screen():
		if direction == "left":
			velocity.x -= speed
		else:
			velocity.x += speed
	
		# Gravity
		velocity.y += gravity * delta
		
	# Applying the velocity
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.y += gravity * delta
	


func _on_DetectorLeft_body_entered(_body):
	direction = "right"
	detector_left.set_deferred("disabled", true)
	detector_right.set_deferred("disabled", false)


func _on_DetectorRight_body_entered(_body):
	direction = "left"
	detector_left.set_deferred("disabled", false)
	detector_right.set_deferred("disabled", true)


func _on_Sprite_animation_finished():
	if $Sprite.animation == "die":
		queue_free()


func take_damage():
	state = "dead"
	if powerup == "super_star":
		$AnimationPlayer.play("super_hit")
		velocity += Vector2(300, -800) 
		
	else:
		velocity.x = 0
		velocity.y = 0
		$Sprite.animation = "die"
	$Detector.queue_free()
	
func block_hit():
	pass


func _on_HitBox_body_entered(body):
	if body.is_in_group("Player"):
		print(body.name)
		body.take_damage()
		if body.velocity.y < 0.1 and state == "alive":
			pass
			
