extends PlayerState
class_name PlayerRunState

func enter() -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	apply_animation(direction)

func execute(_delta: float) -> void:
	# Input
	var direction := Input.get_vector("left", "right", "up", "down")
	
	# Transition
	if direction == Vector2.ZERO:
		state_machine.transition_to(PlayerStateMachine.State.IDLE)
		return
	
	if Input.is_action_just_pressed("roll"):
		state_machine.transition_to(PlayerStateMachine.State.ROLL)
		return
	
	# Animation
	apply_animation(direction)

	# Logic
	player.velocity = direction * player.speed
	player.move_and_slide()

func apply_animation(direction: Vector2) -> void:
	if direction.x != 0:
		player.sprite_base.play("run")
		player.sprite_base.flip_h = direction.x < 0
	elif direction.y != 0:
		player.sprite_base.play("run_down" if player.velocity.y > 0 else "run_up")
