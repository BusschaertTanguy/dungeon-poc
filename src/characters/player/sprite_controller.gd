extends Node2D
class_name SpriteController

var sprites: Array[AnimatedSprite2D]
var animation: String
var flip_h: bool
var time: float
var loop: bool

func _ready() -> void:
	reset()
	
	for child in get_children():
		if child is AnimatedSprite2D:
			sprites.append(child)

func reset() -> void:
	animation = ""
	flip_h = true
	time = 0.0
	loop = true

func play() -> void:
	for sprite in sprites:
		if sprite.sprite_frames.get_animation_names().find(animation) == -1:
			sprite.visible = false
			sprite.stop()
			continue
		
		if time != 0:
			var speed := sprite.sprite_frames.get_frame_count(animation) / time
			sprite.sprite_frames.set_animation_speed(animation, speed)
		
		sprite.sprite_frames.set_animation_loop(animation, loop)
		
		sprite.visible = true
		sprite.play(animation)
		sprite.flip_h = flip_h
