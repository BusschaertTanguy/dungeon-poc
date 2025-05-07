extends PlayerState
class_name PlayerStateJump

var jump_direction := Vector2.ZERO
var jump_cooldown := 0.6
var jump_timer := 0.0

func enter() -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	jump_timer = jump_cooldown
	
	# Animation
	var sprite = player.sprite_controller
	sprite.loop = false
	sprite.time = jump_cooldown
	
	if direction == Vector2.ZERO:
		sprite.animation = "jump_down"
	elif direction.x != 0:
		sprite.animation = "jump"
		sprite.flip_h = direction.x < 0
	elif direction.y != 0:
		sprite.animation = "jump_down" if direction.y > 0 else "jump_up"
	
	sprite.play()
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
