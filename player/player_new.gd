extends KinematicBody2D

# Properties
var object_name:= "player_new"
export var health := 1
export var state_powerup := ""
var state := "idle"
var move_state := "stop"
var current_state : String
var current_size := "none"
var sizes := {
			"small": {
				"sprite_pos": Vector2(0, -32), 
				"body_pos": Vector2(0, -32), 
				"head_pos": Vector2(-2, -62),
				"feet_pos": Vector2(0, -4),
				
				"body_size": Vector2(24, 28),
				"feet_size": Vector2(24, 4),
				},
			"big": {
				"sprite_pos": Vector2(0, -64), 
				"body_pos": Vector2(0, -64), 
				"head_pos": Vector2(2, -126),
				"feet_pos": Vector2(0, -4),				
				
				"body_size": Vector2(28, 60),
				"feet_size": Vector2(32, 4),
				}
			} 
var move_states := {"normal": {
						"gravity": 1300.0, 
						"jump_force": 860, 
						"acceleration": 0.01,
						"friction": 0.1,
						"speed": 500},
					"swim": {
						"gravity": 500.0, 
						"jump_force": 300, 
						"acceleration": 0.01,
						"friction": 0.1,
						"speed": 600},
					"stop": {}
						}
var states := ["idle", "walk", "run", "jump", "swim_up", "fall", "powerup"]

# Movement
export var speed := 500
export var gravity := 2000
export var jump_force := 1050
export var acceleration := 0.01
export var friction := 0.1
var velocity := Vector2.ZERO
var max_velocity := Vector2(0, -100)
var input_direction := Vector2.ZERO
var input_is_just_pressed := Vector2.ZERO
var direction := 0.0
var grounded := false
var input_run := false

signal pause_game

# Components
onready var sprite = get_node("AnimatedSprite")
onready var anim_player = get_node("AnimationPlayer")
onready var player_body = get_node("CollisionShape2D")
onready var player_head = get_node("DetectorHead")
onready var player_feet = get_node("DetectorFeet")

func _ready():
	powerup("small")
	set_move_state("normal")


func _process(_delta):
	debug()
	if not state == "die":
		get_input()
		call(move_state)


func _physics_process(delta):
	if not move_state == "stop":
		# Gravity
		if velocity.y < 1000:
			velocity.y += gravity * delta
			
		call(state)
		
		if not direction == 0:
			velocity.x = lerp(velocity.x, direction * speed, acceleration)
		if not direction == sign(velocity.x):
			velocity.x = lerp(velocity.x, 0, friction)
			
		velocity = move_and_slide(velocity, Vector2.UP)
		
		block_collisons()


func debug():
	var position_round = Vector2(round(position.x), round(position.y))
	var velocity_round = Vector2(round(velocity.x), round(velocity.y))
	Debug.display_info("Player", {
								"POS": position_round, 
								"Velocity": velocity_round,
								"Direction": direction,
								"Input Direction": input_direction,
								"Input Run": input_run,
								"Size": current_size,
								"State": state,
								"Move State": move_state,
								"Powerup State": state_powerup,
								"grounded": grounded,
								"Jump Force": jump_force,
								"animation": anim_player.current_animation,
								})
	
#	if Input.is_action_just_pressed("debug"):
#		anim_player.play("mushroom")
#		powerup("mushroom")


func get_input():
	if Input.is_action_just_pressed("move_left"):
		input_direction.x -= 1
	if Input.is_action_just_pressed("move_right"):
		input_direction.x += 1
	if Input.is_action_just_pressed("jump"):
		input_direction.y = -1
	if Input.is_action_just_pressed("run_attack"):
		input_run = true

	if Input.is_action_just_released("move_left"):
		input_direction.x += 1
	if Input.is_action_just_released("move_right"):
		input_direction.x -= 1
	if Input.is_action_just_released("jump"):
		input_direction.y = 0
	if Input.is_action_just_released("run_attack"):
		input_run = false


func set_state(new_state):
	if not state == new_state:
		state = new_state


func set_move_state(new_state):
	if move_states.has(new_state):
		if new_state == "stop":
			move_state = new_state
		elif move_state != new_state:
			move_state = new_state
			gravity = move_states[new_state].gravity
			jump_force = move_states[new_state].jump_force
			speed = move_states[new_state].speed
	else:
		printerr(new_state + " is not a valid move state")

func block_collisons():
	var blocks = player_head.get_overlapping_areas()
	for block in blocks:
		if block.is_in_group("BlockHit") and state == "jump":
			block.get_owner().block_hit(state_powerup)


func size(player_size):
	if player_size != current_size and sizes.has(player_size):
			sprite.animation = player_size
			
			sprite.position = sizes[player_size].sprite_pos
			player_body.position = sizes[player_size].body_pos
			player_head.position = sizes[player_size].head_pos
			player_feet.position = sizes[player_size].feet_pos
			
			player_body.shape.extents = sizes[player_size].body_size
			player_feet.get_node("CollisionShape2D").shape.extents = sizes[player_size].feet_size
			
			current_size = player_size
	pass


func movement():
	if not grounded and is_on_floor():
			grounded = true
	if grounded and not is_on_floor():
			grounded = false


func flip_direction():
	if direction > 0 and sprite.flip_h:
		sprite.flip_h = not sprite.flip_h
	elif direction < 0 and not sprite.flip_h:
		sprite.flip_h = not sprite.flip_h


# Move state functions
func normal():
	input_direction.normalized()
	direction = input_direction.x
	
	if velocity.y > 0:
		set_state("fall")
		pass
			
	if grounded:
		if not input_direction.x == 0:
			if input_run:
				set_state("run")
			else:
				set_state("walk")
			pass
		if input_direction.y == -1:
			set_state("jump")
			
	movement()


func swim(): 
	var normal_input = input_direction.normalized()
	direction = normal_input.x
	
	if velocity.y < 0:
		anim_player.play("swim_up")
	elif velocity.y > 0:
		anim_player.play("swim_down")
		
	if grounded:
		if velocity.y == 0:
			set_state("idle")
			pass
		if not input_direction.x == 0 and not state == "swim_up":
			pass
			set_state("walk")
	
	if input_direction.y < 0 and not anim_player.current_animation == "swim_up":
		set_state("swim_up")
		
#	if velocity
	movement()
	flip_direction()


# Move functions
func idle():
	if not anim_player.current_animation == "idle":
		anim_player.play("idle")


func walk():
	if abs(velocity.x) < 30:
		set_state("idle")
	elif not sign(velocity.x) == direction and abs(direction) == 1:
			anim_player.play("turn")
	elif not anim_player.current_animation == "walk":
		anim_player.play("walk")
		speed = 500
		acceleration = 0.02
		
	flip_direction()

func run():
	if abs(velocity.x) < 30:
		set_state("idle")
	elif not sign(velocity.x) == direction and abs(direction) == 1:
			anim_player.play("turn")
	elif not anim_player.current_animation == "run":
		anim_player.play("run")
		speed = 800
		acceleration = 0.04
	
	flip_direction()
	

func jump():
	if grounded and input_direction.y == -1:
		velocity.y -= jump_force
		grounded = false
		anim_player.play("jump")
		input_direction.y = 0


func swim_up():
	if input_direction.y < 0:
		velocity.y = jump_force * -1
		input_direction.y = 0


func fall():
	if grounded:
		set_state("idle")
		pass


func stop():
	
	pass


func powerup(powerup_item):
	if not state_powerup == powerup_item:
		velocity = Vector2.ZERO
		direction = 0	
		set_state("idle")
		emit_signal("pause_game")
		match powerup_item:	
			"small":
				sprite.animation = "small"
				size("small")
				health = 1
				state_powerup = "small"
			"mushroom":
				size("big")
				set_move_state("stop")		
				health = 2
				state_powerup = "mushroom"
				anim_player.play("mushroom")
				world_properties.pause_game = true
				$PowerupTimer.start()				
			"fire_flower":
				size("big")
				set_move_state("stop")
				health = 2
				state_powerup = "fire_flower"
				$SuperStar.play("fire_flower")
				$PowerupTimer.start()
				


func _on_animation_finished(anim_name):
	if anim_name == "mushroom":
		set_move_state("normal")
		set_state("idle")
		world_properties.pause_game = false


func _on_PowerupTimer_timeout():
	set_move_state("normal")
	set_state("idle")
	world_properties.pause_game = false
	$SuperStar.stop()
	if state_powerup == "fire_flower":
		sprite.shader_param/new_overalls = Color()
		
