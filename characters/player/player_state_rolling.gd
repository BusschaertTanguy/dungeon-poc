class_name PlayerStateRolling
extends PlayerState

var roll_speed = 0.0
var roll_direction = Vector2.ZERO
var roll_timer = 0.0
	
func enter(args := {}) -> void:
	roll_direction = args.get("direction", Vector2.ZERO)
	assert(roll_direction != Vector2.ZERO)
	
	roll_speed = player.speed * 1.5
	
	# Animation
	if roll_direction.x != 0:
		player.sprite_base.animation = "roll"
		player.sprite_base.flip_h = roll_direction.x < 0
		roll_timer = player.sprite_base.sprite_frames.get_frame_count(player.sprite_base.animation) / player.sprite_base.sprite_frames.get_animation_speed(player.sprite_base.animation)
	elif roll_direction.y != 0:
		player.sprite_base.animation = "roll_down" if roll_direction.y > 0 else "roll_up"
		roll_timer = player.sprite_base.sprite_frames.get_frame_count(player.sprite_base.animation) / player.sprite_base.sprite_frames.get_animation_speed(player.sprite_base.animation)


func handle(direction: Vector2, delta: float) -> PlayerState.Type:
	# Roll lock
	roll_timer -= delta
	
	# Movement
	player.velocity = roll_direction * roll_speed
	
	# Transition
	if roll_timer > 0:
		return PlayerState.Type.ROLLING
	
	roll_direction = Vector2.ZERO
	roll_timer = 0
	
	if direction == Vector2.ZERO:
		return PlayerState.Type.IDLE
	
	if(direction != Vector2.ZERO):
		return PlayerState.Type.RUNNING
	
	return PlayerState.Type.ROLLING
