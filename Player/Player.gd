extends KinematicBody2D

export var object_name = "player"
#var score : int = Global.score
var score : int = 0

# Physics
export var speed : int = 400
export var jump_force : int = 1400
export var enemy_bounce : int = 600
var gravity = world_properties.gravity
export var health : int = 1
export var state = "idle"
export var state_powerup = "small"
onready var player = get_node("PlayerSmall/DetectorHead")

var velocity : Vector2 = Vector2()
var grounded : bool = true
var jumping : bool = false
var direction : String = "right"
var on_floor

# Components
export onready var sprite = $AnimatedSprite
signal current_state(state)


func _ready():
	pass


func debug():
	Debug.display_info("Player", 
						{"Jumping": jumping, 
						"Grounded": grounded, 
						"On Floor": on_floor,
						"Health": health,
						"Position": position,
						"State": state})
	
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
		set_state("jump")


func player_animation():
#	Debug.display_info("Player", {"Anim": $AnimationPlayer.current_animation,
#									"State": state})
					
	if state != "jump":
		if velocity.x == 0:
			set_state("idle")
		else:
			set_state("walk")
	
		if direction == "left":
			pass
			sprite.flip_h = true
		else:
			pass
			sprite.flip_h = false
	
	if $AnimationPlayer.current_animation != "state":
		$AnimationPlayer.play(state)


func set_state(state_name):
	if state != state_name:
		state = state_name
		emit_signal("current_state", state)


func _physics_process(delta):
	
	velocity.x = 0
	if health > 0:
		get_input()
	
	
	# Gravity
	velocity.y += gravity * delta

	# Direction
	
	# Applying the velocity
	velocity = move_and_slide(velocity, Vector2.UP)
	
	#Jumping
	if !grounded and is_on_floor():
		grounded = true
		set_state("idle")
	if jumping and grounded:
		jumping = false
		
	if !is_on_floor() and $JumpTimer.is_stopped() and !jumping:
		$JumpTimer.start()


func _process(_delta):
#	sprite.position = player.position
	debug()
	player_animation()
	get_block_collisions()
	
	
	if state_powerup == "mushroom" and sprite.position.y != 32:
		sprite.animation = "mushroom"
		sprite.position.y = -32
		player = $PlayerBig/DetectorHead
		$PlayerBig.set_deferred("disabled", false)
		$PlayerSmall.set_deferred("disabled", true)
	elif state_powerup == "small" and sprite.position.y != 0:
		sprite.animation = "small"
		sprite.position.y = 0
		player = $PlayerSmall/DetectorHead
		$PlayerBig.set_deferred("disabled", true)
		$PlayerSmall.set_deferred("disabled", false)
	
	
	


func _on_JumpTimer_timeout():
	grounded = false

func get_block_collisions():
	var bodies = player.get_overlapping_bodies()
	for i in bodies:
		if i.is_in_group("Block") and state == "jump":
			i.block_hit("small")


func _on_DetectorFeet_area_shape_entered(_area_id, area, _area_shape, _self_shape):
	if area.get_parent().is_in_group("Enemy"):
		
		if area.get_parent().state == "alive":
			if velocity.y > 0:
				velocity.y = 0
				velocity.y -= enemy_bounce
				area.get_parent().take_damage()


func take_damage():
	health -= 1
	if health == 0:
		set_state("die")
#		$CollisionShape2D.set_deferred("disabled", true)
#		$DetectorFeet/CollisionShape2D.set_deferred("disabled", true)
#		$DetectorHead/CollisionShape2D.set_deferred("disabled", true)


func _on_DetectorFeet_area_entered(_area):
#	if area.get_parent().state == "alive":
#		if velocity.y > 0:
#			velocity.y = 0
#			velocity.y -= enemy_bounce
#			area.get_parent().take_damage()
	pass
#
