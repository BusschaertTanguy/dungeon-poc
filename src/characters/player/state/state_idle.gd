extends PlayerState
class_name PlayerIdleState

func enter() -> void:
	player.sprite_controller.apply_animation("idle")

func execute(_delta: float) -> void:
	# Input
	var direction := Input.get_vector("left", "right", "up", "down")
	
	# Transition
	if(Input.is_action_just_pressed("jump")):
		state_machine.transition_to(PlayerStateMachine.State.JUMP)
		return
	
	if(direction != Vector2.ZERO):
		state_machine.transition_to(PlayerStateMachine.State.RUN)
		return
	
	# Physics
	player.velocity = Vector2.ZERO
