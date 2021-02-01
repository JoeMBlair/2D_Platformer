tool
extends StaticBody2D

#export var default_item : String = "none"
export var held_item : String = "none"
var animation_player : AnimationPlayer
export var sprite : SpriteFrames
export var health : int = 1
signal block_hit_response(powerup, item)
var one_shot = false

func _ready():
	if Engine.editor_hint:
		pass
	else:
		$AnimatedSprite.set_sprite_frames(sprite)


func _process(_delta):
	if Engine.editor_hint:
		editor_logic()
	else:
		$Label.text = str($DetectorItem.get_overlapping_areas())
		if not one_shot:
			one_shot = true
		
		# Sets HeldItem sprite to currently held_item varible with live update in editor
#		var bodies = $DetectorItem.get_overlapping_bodies()
#		if bodies.size() != 0:
#			for body in bodies:
#				if "item_name" in body:
#					held_item = body.item_name
#					body.queue_free()

	if $HeldItem.animation != self.get("held_item"):
			$HeldItem.animation = held_item
	
	if health == 0:
		pass

func _physics_process(_delta):
	if Engine.editor_hint:
		pass
	else:
		pass


func editor_logic():
	# Loads SpritesFrame resource from file picker in editor
		if $AnimatedSprite.frames != self.get("sprite"):
			
			$AnimatedSprite.set_sprite_frames(sprite)


func block_hit(powerup):
	if health > 0:
		emit_signal("block_hit_response", powerup, held_item)
		$AnimationPlayer.play("hit")
		if not held_item == "none":
			var item_instance = instance_item(held_item)
			item_instance.spawn_item()	
			held_item = "none"
		else:
			pass

func instance_item(item):
	var filename = get_objects.object_paths[item]
	var item_instance = load(filename).instance()
#	call_deferred("add_child", item_instance)
	add_child(item_instance)
	var position = Vector2(0, 0)
	item_instance.position = position
	return item_instance
	pass

#
#func _on_DetectorItem_area_entered(area):
#	if area.is_in_group("LoadItem"):
#		var item = area.get_owner().item_name
#		$DetectorItem/CollisionShape2D.set_deferred("disabled", true)
#		area.get_owner().queue_free()
#		held_item = item


#func _on_DetectorBreak_body_entered(body):
#	if body.is_in_group("Player") and body.state == "jump":
#		var powerup = body.state_powerup
#		block_hit(powerup)
#	pass # Replace with function body.
