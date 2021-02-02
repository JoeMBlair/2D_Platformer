extends KinematicBody2D

# Properties
var object_name:= "player_new"
var health := 1
var state_powerup := ""
var state := "idle"
var invunerable := false
var move_state := "stop"
var current_size := "none"
var powerup_stop := true
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
var powerups := {"small": {
							"size": "small",
							"health": 1,
							"anim": "small",
							"pause_time": 0,
							"colours": ["#ff3118", "#c66300", "ff945a"],
							"powerup_stop": true,
							"power_level": 1,
							}, 
						"mushroom": {
							"size": "big",
							"health": 2,
							"anim": "mushroom",
							"pause_time": 1,
							"colours": ["#ff3118", "#c66300", "ff945a"],
							"powerup_stop": true,
							"power_level": 2,
							}, 
						"fire_flower": {
							"size": "big",
							"health": 2,
							"anim": "fire_flower",
							"pause_time": 1,
							"colours": ["#ffffff", "#ff3118", "ff945a"],
							"powerup_stop": false,
							"power_level": 3,
							}, 
						"super_star": {
							"size": "none",
							"health": 0,
							"anim": "super_star",
							"pause_time": 0,
							"colours": ["#ff3118", "#c66300", "ff945a"],
							"powerup_stop": false,
							"previous_state": "none",
							"power_level": 4,
							}}
var move_modes := {"normal": {
						"gravity": world_properties.gravity, 
						"jump_force": 1500, 
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
var states := ["idle", "walk", "run", "jump", "swim_up", "fall", "powerup", "die"]

# Movement
var velocity := Vector2.ZERO
export var speed := 500
onready var gravity = world_properties.gravity
export var jump_force := 1050
export var enemy_bounce_force : int = 600
export var acceleration := 0.01
export var friction := 0.1
var direction := 0.0
var grounded := false

#Input
var input_direction := Vector2.ZERO
var input_run := false
var input_attack := false

var state_history := []
var pup_history := []

# Components
onready var sprite = get_node("AnimatedSprite")
onready var anim_player = get_node("AnimationPlayer")
onready var powerup_player = get_node("PowerupPlayer")
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
		if not powerup_stop:
			call(state_powerup)


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
	elif move_state == "stop" and state == "die": 
		call(state, delta)


func debug():
	var position_round = Vector2(round(position.x), round(position.y))
	var velocity_round = Vector2(round(velocity.x), round(velocity.y))
	Debug.display_info("Player", {
								"POS": position_round, 
								"Velocity": velocity_round,
								"Direction": direction,
								"Health": health,
								"Invunerable": invunerable,
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
	if Input.is_action_just_pressed("run"):
		input_run = true
	if Input.is_action_just_pressed("attack"):
		input_attack = true

	if Input.is_action_just_released("move_left"):
		input_direction.x += 1
	if Input.is_action_just_released("move_right"):
		input_direction.x -= 1
	if Input.is_action_just_released("jump"):
		input_direction.y = 0
	if Input.is_action_just_released("run"):
		input_run = false
	if Input.is_action_just_released("attack"):
		input_attack = false


func set_state(new_state):
	if not state == new_state:
		state = new_state


func set_move_state(new_state):
	if move_modes.has(new_state):
		if new_state == "stop":
			move_state = new_state
		elif move_state != new_state:
			move_state = new_state
			gravity = move_modes[new_state].gravity
			jump_force = move_modes[new_state].jump_force
			speed = move_modes[new_state].speed
	else:
		printerr(new_state + " is not a valid move state")

func block_collisons():
	var blocks = player_head.get_overlapping_areas()
	for block in blocks:
		if block.is_in_group("BlockHit") and state == "jump":
			block.get_owner().block_hit(state_powerup)
			return


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
#	input_direction.normalized()
	direction = input_direction.x
	
	if input_attack:
		pass
	
	if velocity.y > 0:
		set_state("fall")
		pass
		
	if input_run:
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
	if input_direction.y == 0:
		velocity.y = 0
		set_state("fall")


func swim_up():
	if input_direction.y < 0:
		velocity.y = jump_force * -1
		input_direction.y = 0


func fall():
	if grounded:
		set_state("idle")
		input_direction.y = 0
		
		pass


func super_star():
	invunerable = true
	powerup_player.play("super_star")
	yield(get_tree().create_timer(5.0), "timeout")
	powerup_player.stop()
	var colours = powerups["super_star"].colours
	set_colours(colours[0], colours[1], colours[2])
	invunerable = false
	var prev_state = powerups["super_star"].previous_state
	powerup_stop = powerups[prev_state].powerup_stop
	state_powerup = prev_state
	pass


func fire_flower():
	
	pass

func stop():
	pass

func powerup(p_item):
	if not state_powerup == p_item:
		var p_size = powerups[p_item].size
		var p_health = powerups[p_item].health
		var p_anim = powerups[p_item].anim
		var pause_time = powerups[p_item].pause_time
		var p_colours = powerups[p_item].colours
		var p_timer = get_node("PowerupTimer")
		var p_stop = powerups[p_item].powerup_stop
		
		state_powerup = p_item
		size(p_size)
		if not p_health == 0:
			health = p_health
		powerup_stop = p_stop
		if pause_time > 0:
			anim_player.stop(false)
			set_move_state("stop")
			powerup_player.play(p_anim)
			p_timer.wait_time = pause_time
			world_properties.pause_game = true
			p_timer.start()
			yield(get_node("PowerupTimer"), "timeout")
			anim_player.play()
			
		set_colours(p_colours[0], p_colours[1], p_colours[2])		
		powerup_player.stop()
		world_properties.pause_game = false
		set_move_state("normal")


func set_colours(overalls, shirt, skin):
	sprite.material.set_shader_param("new_overalls", Color(overalls))
	sprite.material.set_shader_param("new_shirt", Color(shirt))	
	sprite.material.set_shader_param("new_skin", Color(skin))
	pass


func take_damage():
	if not invunerable:
		invunerable = true
		world_properties.pause_game = true
		move_state = "stop"	
		health -= 1
		if health == 1:
			anim_player.play("hit")
			yield(get_node("AnimationPlayer"), "animation_finished")
			world_properties.pause_game = false
			move_state = "normal"
			powerup("small")			
			yield(get_tree().create_timer(3), "timeout")
			sprite.modulate = Color(1, 1, 1, 1)
			invunerable = false			
		elif health == 0:
			set_state("die")


func die(delta):
	if invunerable:
		z_index = 2
		anim_player.play("die")
		yield(get_node("AnimationPlayer"), "animation_finished")
		$CollisionShape2D.set_deferred("disabled", true)
		invunerable = false
	velocity.x = 0
	velocity.y += 5000 * delta	
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_DetectorFeet_area_entered(area):
	if area.get_owner().is_in_group("Enemy"):
		if state_powerup == "super_star":
			area.get_owner().powerup = "super_star"
			area.get_owner().take_damage()	
					
			if state == "fall":
				velocity.y = enemy_bounce_force * -1
		elif state == "fall":
			velocity.y = enemy_bounce_force * -1
			area.get_owner().take_damage()

