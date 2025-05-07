extends PlayerState
class_name PlayerStateJump

var jump_direction := Vector2.ZERO
var jump_cooldown := 0.6
var jump_timer := 0.0

func enter() -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	jump_timer = jump_cooldown
	
	# Animation
	if direction == Vector2.ZERO:
		player.sprite_controller.play("jump_down", false, jump_cooldown, false)
	elif direction.x != 0:
		player.sprite_controller.play("jump", direction.x < 0, jump_cooldown, false)
	elif direction.y != 0:
		player.sprite_controller.play("jump_down" if direction.y > 0 else "jump_up", jump_cooldown, false)
	
	jump_direction = direction

func exit() -> void:
	jump_direction = Vector2.ZERO
	jump_timer = 0.0

func execute(delta: float) -> void:
	# Decrease roll timer
	jump_timer -= delta
	
	# Physics
	if jump_direction != Vector2.ZERO && jump_timer > -delta:
		player.velocity = jump_direction * player.speed
		player.move_and_slide()
	
	if jump_timer > 0:
		return
	
	# Transition
	var direction := Input.get_vector("left", "right", "up", "down")
	state_machine.transition_to(PlayerStateMachine.State.IDLE if direction == Vector2.ZERO else PlayerStateMachine.State.RUN)
