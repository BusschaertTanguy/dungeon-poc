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
	
	if(Input.is_action_just_pressed("jump")):
		state_machine.transition_to(PlayerStateMachine.State.JUMP)
		return
	
	if(Input.is_action_just_pressed("attack")):
		state_machine.transition_to(PlayerStateMachine.State.ATTACK)
		return
	
	# Animation
	apply_animation(direction)

	# Physics
	player.velocity = direction * player.speed
	player.move_and_slide()

func apply_animation(direction: Vector2) -> void:
	var sprite = player.sprite_controller
	
	if direction.x != 0:
		sprite.animation = "run"
		sprite.flip_h = direction.x < 0
	elif direction.y != 0:
		sprite.animation = "run_down" if player.velocity.y > 0 else "run_up"
	
	sprite.play()
