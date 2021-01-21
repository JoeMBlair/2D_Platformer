extends Node

var score : int = Global.score

# Physics
export var speed : int = 400
export var jump_force : int = 1400
export var enemy_bounce : int = 600
export var gravity : int = Global.gravity
export var health : int = 1
export var state = "idle"
export var state_powerup = "small"

var velocity : Vector2 = Vector2()
var grounded : bool = true
var jumping : bool = false
var direction : String = "right"
var on_floor
var position

# Components
onready var sprite = $
onready var player = $PlayerSmall


func _ready():
	pass


func debug():
	on_floor = player.is_on_floor()
	Debug.display_info("Player", 
						{"Jumping": jumping, 
						"Grounded": grounded, 
						"On Floor": on_floor,
						"Health": health,
						"Position": position})
	
	if Input.is_action_just_released("debug"):
		$AnimationPlayer.play("die")


func get_input():
	# Movement inputs
	var left = Input.is_action_pressed("move_left")
	var right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_just_pressed("jump")
	
	if left:
		velocity.x -= speed
		direction = "left"
	elif right:
		velocity.x += speed
		direction = "right"
		
	if jump and grounded:
		velocity.y = 0
		velocity.y -= jump_force
		jumping = true
		grounded = false
		state = "jump"


func player_animation():
#	Debug.display_info("Player", {"Anim": $AnimationPlayer.current_animation,
#									"State": state})
					
	if state != "jump":
		if velocity.x == 0:
			state = "idle"
		else:
			state = "walk"
	
		if direction == "left":
			pass
#			sprite.flip_h = true
		else:
			pass
#			sprite.flip_h = false
	
	if $AnimationPlayer.current_animation != "state":
		$AnimationPlayer.play(state)


func set_state():
	pass

func _physics_process(delta):
	
	player_animation()
	debug()
	velocity.x = 0
	if health > 0:
		get_input()
	
	
	# Gravity
	velocity.y += gravity * delta

	
	
	# Direction
	

	# Applying the velocity
	velocity = player.move_and_slide(velocity, Vector2.UP)
	
	#Jumping
	if !grounded and on_floor:
		grounded = true
		state = "idle"
	if jumping and grounded:
		jumping = false
		
	if !on_floor and $JumpTimer.is_stopped() and !jumping:
		$JumpTimer.start()


func _on_JumpTimer_timeout():
	grounded = false


func _on_DetectorFeet_area_shape_entered(_area_id, area, _area_shape, _self_shape):
	if area.get_parent().is_in_group("Enemy"):
		
		if area.get_parent().state == "alive":
			if velocity.y > 0:
				velocity.y = 0
				velocity.y -= enemy_bounce
				area.get_parent().take_damage()


func take_damage():
	if health == 0:
		state = "die"
#		$CollisionShape2D.set_deferred("disabled", true)
		$DetectorFeet/CollisionShape2D.set_deferred("disabled", true)
		$DetectorHead/CollisionShape2D.set_deferred("disabled", true)

