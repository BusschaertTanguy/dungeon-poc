extends PlayerState
class_name PlayerStateAttack

var attack_hurtbox: Area2D
var attack_direction: Vector2
var attack_cooldown := 0.5
var attack_timer := 0.0
var attack_range := 5.0

var player_speed_multiplier := 0.5

func on_hurtbox_collision(other) -> void:
	pass

func enter() -> void:
	attack_direction = Input.get_vector("left", "right", "up", "down")
	
	if attack_direction == Vector2.ZERO:
		attack_direction = Vector2.DOWN
	
	attack_timer = attack_cooldown

	# Hurtbox
	attack_hurtbox = Area2D.new()
	attack_hurtbox.body_entered.connect(on_hurtbox_collision)
	
	var attack_hurtbox_rectangle = RectangleShape2D.new()
	var attack_hurtbox_collision := CollisionShape2D.new()
	
	if attack_direction.x != 0:
		attack_hurtbox_rectangle.size = Vector2(10, 20)
		attack_hurtbox_collision.position.y = -attack_hurtbox_rectangle.size.y / 2
		attack_hurtbox_collision.position.x = attack_range if attack_direction.sign().x > 0 else -attack_range - attack_hurtbox_rectangle.size.x
	elif attack_direction.y != 0:
		attack_hurtbox_rectangle.size = Vector2(20, 10)
		attack_hurtbox_collision.position.y = attack_range if attack_direction.sign().y > 0 else -attack_range - attack_hurtbox_rectangle.size.y
		attack_hurtbox_collision.position.x = -attack_hurtbox_rectangle.size.x / 2
	
	attack_hurtbox.collision_mask = 2
	attack_hurtbox_collision.shape = attack_hurtbox_rectangle
	
	# Visual representation of hurtbox, for debug purposes
	var attack_hurtbox_color := ColorRect.new()
	attack_hurtbox_color.color = Color(1, 0, 0, 0.3)
	attack_hurtbox_color.size = attack_hurtbox_rectangle.size
	attack_hurtbox_color.position = attack_hurtbox_collision.position
	
	attack_hurtbox.add_child(attack_hurtbox_collision)
	attack_hurtbox.add_child(attack_hurtbox_color)
	player.add_child(attack_hurtbox)
	
	# Animation
	var sprite = player.sprite_controller
	sprite.reset()
	sprite.loop = false;
	sprite.time = attack_cooldown
	
	if attack_direction.x != 0:
		sprite.animation = "attack"
		sprite.flip_h = attack_direction.x < 0
	elif attack_direction.y != 0:
		sprite.animation = "attack_down" if attack_direction.y > 0 else "attack_up"
	
	sprite.play()

func exit() -> void:
	player.remove_child(attack_hurtbox)
	attack_hurtbox.queue_free()

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
