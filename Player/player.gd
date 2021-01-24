extends KinematicBody2D

export var object_name = "player"
#var score : int = Global.score
var score : int = 0

# Physics
export var speed : int = 400
export var jump_force : int = 1400
export var enemy_bounce_force : int = 600
var gravity = world_properties.gravity
export var health : int = 1
export var state = "idle"
export var state_powerup = "small"
var hit_block = false
#onready var player = get_node("PlayerSmall/DetectorHead")

var velocity : Vector2 = Vector2()
var grounded : bool = true
var jumping : bool = false
var direction : String = "right"
var on_floor

# Components
export onready var sprite = $AnimatedSprite
onready var player_body = get_node("PlayerSmall")
onready var player_head = get_node("PlayerSmall/DetectorHead")
onready var player_feet = get_node("PlayerSmall/DetectorFeet")
signal current_state(state)


func _ready():
	set_state_powerup(state_powerup)
	get_node("PlayerSmall/DetectorBody").connect("body_entered", self, "on_body_touch")
	get_node("PlayerSmall/DetectorHead").connect("area_entered", self, "on_head_touch")
	get_node("PlayerSmall/DetectorFeet").connect("area_entered", self, "on_feet_touch")	
	pass


func debug():
	Debug.display_info("Player", 
						{"Jumping": jumping, 
						"Grounded": grounded, 
						"On Floor": on_floor,
						"Health": health,
						"Position": position,
						"State": state,
						"power up state": state_powerup,
						"Velocity": velocity})
	
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
		grounded = false
		set_state("jump")

func flip_direction():
	sprite.flip_h = not sprite.flip_h
	


func player_animation():
#	Debug.display_info("Player", {"Anim": $AnimationPlayer.current_animation,
#									"State": state})
	if state != "die":
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
	


func set_state(state_name):
	if state != "die":
		if state != state_name:
			state = state_name
			if state != "fall":
				$AnimationPlayer.play(state)

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
		hit_block = false
		set_state("idle")
	if state == "jump" and grounded:
		pass
	if velocity.y > 400:
		set_state("fall")
		
	if !is_on_floor() and $JumpTimer.is_stopped() and state != "jump":
		$JumpTimer.start()


func set_state_powerup(powerup):
	if state_powerup != powerup:
		player_feet.disconnect("area_entered", self, "on_feet_touch")
		player_body.disconnect("body_entered", self, "on_body_touch")
		player_body.set_deferred("disabled", true)
		
		state_powerup = powerup
		
		if state_powerup == "mushroom":
			player_body = $PlayerBig
			player_head = player_body.get_node("DetectorHead")

			sprite.animation = "mushroom"
			
		elif state_powerup == "small":
			player_body = $PlayerSmall
			player_head = player_body.get_node("DetectorHead")
			sprite.animation = "small"
		player_feet = player_body.get_node("DetectorFeet")
		player_body.set_deferred("disabled", false)
		player_feet.connect("area_entered", self, "on_feet_touch")
		
		player_head = player_body.get_node("DetectorHead")

		player_body.connect("body_entered", self, "on_body_touch")
		


func _process(_delta):
	debug()
	player_animation()
	get_block_collisions()


func _on_JumpTimer_timeout():
	grounded = false


func get_block_collisions():
#	var player_head = player_body.get_node("DetectorHead")
	var areas = player_head.get_overlapping_areas()
	for area in areas:
		print(velocity)		
		if area.is_in_group("BlockHit") and not grounded and state == "jump" and not hit_block:
			area.get_owner().block_hit(state_powerup)
			hit_block = true
			return



func _on_DetectorFeet_area_shape_entered(_area_id, area, _area_shape, _self_shape):
	if area.get_parent().is_in_group("Enemy"):
		
		if area.get_parent().state == "alive":
			if velocity.y > 0:
				velocity.y = 0
				velocity.y -= enemy_bounce_force
				area.get_parent().take_damage()


func take_damage():
	health -= 1
	check_health()
	

func check_health():
	if health == 0:
		velocity = Vector2(0, 0)
		set_state("die")
		

func enemy_bounce(area):
	if velocity.y > 0:
		velocity.y = 0
		velocity.y -= enemy_bounce_force
		area.get_owner().take_damage()


func _on_DetectorFeet_body_entered(area):
	if area.get_owner().is_in_group("Enemy"):
		enemy_bounce(area)


func on_feet_touch(area):
	print(area.name)
	print(area)
	if area.get_owner().is_in_group("Enemy"):
		enemy_bounce(area)

func on_body_touch(body):
	print(body.name)	
	if body.is_in_group("Item"):
		var powerup = body.object_collision()
		if powerup != null:
			set_state_powerup(body.item_name)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "die":
		player_body.set_deferred("disabled", true)
		
