extends Node2D
class_name SpriteController

var sprites: Array[AnimatedSprite2D]

func _ready() -> void:
	for child in get_children():
		if child is AnimatedSprite2D:
			sprites.append(child)

func apply_animation(animation: String, flip_h := false) -> void:
	for sprite in sprites:
		sprite.play(animation)
		sprite.flip_h = flip_h
