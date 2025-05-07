extends Node2D
class_name SpriteController

var sprites: Array[AnimatedSprite2D]

func _ready() -> void:
	for child in get_children():
		if child is AnimatedSprite2D:
			sprites.append(child)

func play(animation: String, flip_h := false, time := 0.0, loop := true) -> void:
	for sprite in sprites:
		if sprite.sprite_frames.get_animation_names().find(animation) == -1:
			continue
			
		if time != 0:
			var speed := sprite.sprite_frames.get_frame_count(animation) / time
			sprite.sprite_frames.set_animation_speed(animation, speed)
		
		sprite.sprite_frames.set_animation_loop(animation, loop)
		sprite.play(animation)
		sprite.flip_h = flip_h
