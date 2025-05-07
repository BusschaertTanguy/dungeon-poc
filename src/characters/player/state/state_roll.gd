extends PlayerState
class_name PlayerRollState

var roll_direction := Vector2.ZERO
var roll_cooldown := 0.55
var roll_timer := 0.0

var player_speed_multiplier := 1.5

func enter() -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	roll_direction = direction
	roll_timer = roll_cooldown
	
	# Animation
	var sprite = player.sprite_controller
	sprite.loop = false
	sprite.time = roll_cooldown
	
	if direction.x != 0:
		sprite.animation = "roll"
		sprite.flip_h = direction.x < 0
	elif direction.y != 0:
		sprite.animation = "roll_down" if direction.y > 0 else "roll_up"
	
	sprite.play()

func exit() -> void:
	roll_direction = Vector2.ZERO
	roll_timer = 0.0

func execute(delta: float) -> void:
	# Decrease roll timer
	roll_timer -= delta
	
	# Physics
	if roll_timer > -delta:
		player.velocity = roll_direction * player.speed * player_speed_multiplier
		player.move_and_slide()
	
	if roll_timer > 0:
		return
	
	# Transition
	var direction := Input.get_vector("left", "right", "up", "down")
	state_machine.transition_to(PlayerStateMachine.State.IDLE if direction == Vector2.ZERO else PlayerStateMachine.State.RUN)
