class_name PlayerStateRunning
extends PlayerState

func handle(direction: Vector2, _delta: float) -> PlayerState.Type:
	# Animation
	if direction.x != 0:
		player.sprite_base.animation = "run"
		player.sprite_base.flip_h = player.velocity.x < 0
	elif direction.y != 0:
		player.sprite_base.animation = "run_down" if player.velocity.y > 0 else "run_up"

	# Movement
	player.velocity = direction * player.speed
	
	# Transition
	if direction == Vector2.ZERO:
		return PlayerState.Type.IDLE
	
	if Input.is_action_just_pressed("roll"):
		return PlayerState.Type.ROLLING
	
	return PlayerState.Type.RUNNING
