tool
extends StaticBody2D

export var held_item : String
var animation_player : AnimationPlayer
export var sprite : SpriteFrames
export var health : int = 1
export(String, "test2", "test4") var array
signal block_hit_response(powerup, item)

func _ready():
	if Engine.editor_hint:
		pass
	else:
		$AnimatedSprite.set_sprite_frames(sprite)
		if $DetectorItem.get_overlapping_areas() == []:
			$DetectorItem.set_deferred("disabled", true)


func _process(_delta):
	if Engine.editor_hint:
		editor_logic()
	else:
		# Sets HeldItem sprite to currently held_item varible with live update in editor
		var bodies = $DetectorItem.get_overlapping_bodies()
		if bodies.size() != 0:
			for body in bodies:
				if "item_name" in body:
					held_item = body.item_name
					body.queue_free()

	if $HeldItem.animation != self.get("held_item"):
			$HeldItem.animation = held_item
	
	if health == 0:
		pass

func editor_logic():
	# Loads SpritesFrame resource from file picker in editor
		if $AnimatedSprite.frames != self.get("sprite"):
			
			$AnimatedSprite.set_sprite_frames(sprite)


func block_hit(powerup):
	if health > 0:
		emit_signal("block_hit_response", powerup, held_item)
		$AnimationPlayer.play("hit")
		if held_item != "none":
#			var spawn_item = held_item
			var filename = get_objects.object_paths[held_item]
			var item_instance = load(filename).instance()
			add_child(item_instance)
			var position = Vector2(0, 0)
			item_instance.spawn_item()
			item_instance.position = position
			held_item = "none"
		else:
			pass
	if health == 0:
		pass
#		$DetectorBreak.queue_free()


func _on_DetectorItem_area_entered(area):
	if area.is_in_group("LoadItem"):
		held_item = area.get_owner().item_name
		$DetectorItem/CollisionShape2D.set_deferred("disabled", true)
		area.get_owner().queue_free()

