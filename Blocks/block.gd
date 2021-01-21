tool
extends StaticBody2D

export var held_item = "none"
var animation_player : AnimationPlayer
export var sprite : SpriteFrames
export var health : int = 1
signal block_hit_response(powerup)

func _ready():
	if Engine.editor_hint:
		pass
	else:
		$AnimatedSprite.set_sprite_frames(sprite)


func _process(delta):
	if Engine.editor_hint:
		pass
		editor_logic()
		
	else:
		pass
		
		# Sets HeldItem sprite to currently held_item varible with live update in editor
		var bodies = $DetectorItem.get_overlapping_bodies()
		if bodies.size() != 0:
			for i in bodies:
				if "item_name" in i:
					held_item = i.item_name
					i.queue_free()
	if $HeldItem.animation != self.get("held_item"):
			$HeldItem.animation = held_item

func editor_logic():
	# Loads SpritesFrame resource from file picker in editor
		if $AnimatedSprite.frames != self.get("sprite"):
			$AnimatedSprite.set_sprite_frames(sprite)
# 
func block_hit(powerup):
	if health > 0:
		emit_signal("block_hit_response", powerup)
		$AnimationPlayer.play("hit")
		if held_item != "none":
			var spawn_item = held_item
			held_item = "none"
			
			var filename = "res://Items/" + str(spawn_item) + ".tscn"
			var item_instance = load(filename).instance()
			add_child(item_instance)
			var position = Vector2(0, 0)
			item_instance.spawn_item()
			item_instance.position = position


func _on_DetectorItem_area_entered(area):
	if area.is_in_group("Item"):
		held_item = area.get_parent().item_name
		$DetectorItem/CollisionShape2D.set_deferred("disabled", true)
		area.get_parent().queue_free()
