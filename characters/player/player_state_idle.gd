class_name PlayerStateIdle
extends PlayerState

func handle(direction: Vector2, _delta: float) -> PlayerState.Type:
	# Animation
	player.sprite_base.animation = "idle"
	
	# Movement
	player.velocity = Vector2.ZERO
	
	# Transition
	if(direction != Vector2.ZERO):
		return PlayerState.Type.RUNNING
	
	return PlayerState.Type.IDLE
