extends PlayerState
class_name PlayerIdleState

func enter() -> void:
	player.sprite_base.play("idle")

func execute(_delta: float) -> void:
	# Input
	var direction := Input.get_vector("left", "right", "up", "down")
	
	# Transition
	if(direction != Vector2.ZERO):
		state_machine.transition_to(PlayerStateMachine.State.RUN)
		return
	
	# Logic
	player.velocity = Vector2.ZERO
