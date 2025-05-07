extends PlayerState
class_name PlayerStateJump

var jump_speed := 0.0
var jump_direction := Vector2.ZERO
var jump_timer := 0.0

func enter() -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	
	# Animation
	if direction == Vector2.ZERO:
		player.sprite_controller.apply_animation("jump_down")
	elif direction.x != 0:
		player.sprite_controller.apply_animation("jump", direction.x < 0)
	elif direction.y != 0:
		player.sprite_controller.apply_animation("jump_down" if direction.y > 0 else "jump_up")
	
	jump_speed = player.speed * 1.5
	jump_direction = direction
	jump_timer = calculate_jump_time()

func exit() -> void:
	jump_speed = 0.0
	jump_direction = Vector2.ZERO
	jump_timer = 0

func execute(delta: float) -> void:
	# Decrease roll timer
	jump_timer -= delta
	
	# Physics
	if jump_direction != Vector2.ZERO && jump_timer > -delta:
		player.velocity = jump_direction * jump_speed
		player.move_and_slide()
	
	if jump_timer > 0:
		return
	
	# Transition
	var direction := Input.get_vector("left", "right", "up", "down")
	state_machine.transition_to(PlayerStateMachine.State.IDLE if direction == Vector2.ZERO else PlayerStateMachine.State.RUN)

func calculate_jump_time() -> float:
	var animation = player.sprite_controller.sprites[0].animation
	var sprite_frames = player.sprite_controller.sprites[0].sprite_frames
	return sprite_frames.get_frame_count(animation) / sprite_frames.get_animation_speed(animation)
