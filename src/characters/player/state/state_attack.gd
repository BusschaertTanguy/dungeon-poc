extends PlayerState
class_name PlayerStateAttack

var attack_sprite: AnimatedSprite2D

var attack_direction: Vector2
var attack_cooldown := 0.5
var attack_timer := 0.0

var player_speed_multiplier := 0.5

func enter() -> void:
	attack_direction = Input.get_vector("left", "right", "up", "down")
	attack_timer = attack_cooldown
	
	# Animation
	var sprite = player.sprite_controller
	sprite.loop = false;
	sprite.time = attack_cooldown
	
	if attack_direction == Vector2.ZERO:
		sprite.animation = "attack_down"
	elif attack_direction.x != 0:
		sprite.animation = "attack"
		sprite.flip_h = attack_direction.x < 0
	elif attack_direction.y != 0:
		sprite.animation = "attack_down" if attack_direction.y > 0 else "attack_up"
	
	sprite.play()
	
	var index := player.sprite_controller.sprites.find_custom(filter_attack_sprite)
	attack_sprite = player.sprite_controller.sprites[index]
	attack_sprite.visible = true

func exit() -> void:
	attack_timer = 0.0
	attack_sprite.visible = false

func execute(delta: float) -> void:
	attack_timer -= delta
	
	var direction := Input.get_vector("left", "right", "up", "down")
	player.velocity = direction * player.speed * player_speed_multiplier
	player.move_and_slide()
	
	if attack_timer > 0:
		return
	
	state_machine.transition_to(PlayerStateMachine.State.IDLE if direction == Vector2.ZERO else PlayerStateMachine.State.RUN)

func filter_attack_sprite(sprite: AnimatedSprite2D) -> bool:
	return sprite.name == "Attack"
