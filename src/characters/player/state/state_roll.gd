extends PlayerState
class_name PlayerRollState

var roll_speed := 0.0
var roll_direction := Vector2.ZERO
var roll_timer := 0.0

func enter() -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	
	# Animation
	if direction.x != 0:
		player.sprite_controller.apply_animation("roll", direction.x < 0)
	elif direction.y != 0:
		player.sprite_controller.apply_animation("roll_down" if direction.y > 0 else "roll_up")
	
	roll_speed = player.speed * 1.5
	roll_direction = direction
	roll_timer = calculate_roll_time()

func exit() -> void:
	roll_speed = 0.0
	roll_direction = Vector2.ZERO
	roll_timer = 0.0

func execute(delta: float) -> void:
	# Decrease roll timer
	roll_timer -= delta
	
	# Physics
	if roll_timer > -delta:
		player.velocity = roll_direction * roll_speed
		player.move_and_slide()
	
	if roll_timer > 0:
		return
	
	# Transition
	var direction := Input.get_vector("left", "right", "up", "down")
	state_machine.transition_to(PlayerStateMachine.State.IDLE if direction == Vector2.ZERO else PlayerStateMachine.State.RUN)

func calculate_roll_time() -> float:
	var animation = player.sprite_controller.sprites[0].animation
	var sprite_frames = player.sprite_controller.sprites[0].sprite_frames
	return sprite_frames.get_frame_count(animation) / sprite_frames.get_animation_speed(animation)
