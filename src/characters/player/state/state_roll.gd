extends PlayerState
class_name PlayerRollState

var roll_speed := 0.0
var roll_direction := Vector2.ZERO
var roll_timer := 0.0

func enter() -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	
	roll_speed = player.speed * 1.5
	roll_direction = direction

	# Animation
	if roll_direction.x != 0:
		player.sprite_base.animation = "roll"
		player.sprite_base.flip_h = roll_direction.x < 0
		roll_timer = player.sprite_base.sprite_frames.get_frame_count(player.sprite_base.animation) / player.sprite_base.sprite_frames.get_animation_speed(player.sprite_base.animation)
	elif roll_direction.y != 0:
		player.sprite_base.animation = "roll_down" if roll_direction.y > 0 else "roll_up"
		roll_timer = player.sprite_base.sprite_frames.get_frame_count(player.sprite_base.animation) / player.sprite_base.sprite_frames.get_animation_speed(player.sprite_base.animation)

func exit() -> void:
	roll_direction = Vector2.ZERO
	roll_timer = 0

func execute(delta: float) -> void:
	# Decrease roll timer
	roll_timer -= delta
	
	# Logic
	player.velocity = roll_direction * roll_speed
	player.move_and_slide()
	
	if roll_timer > 0:
		return
	
	# Transition
	var direction := Input.get_vector("left", "right", "up", "down")
	if direction == Vector2.ZERO:
		state_machine.transition_to(PlayerStateMachine.State.RUN)
		return
	
	if(direction != Vector2.ZERO):
		state_machine.transition_to(PlayerStateMachine.State.RUN)
		return
