class_name Player
extends CharacterBody2D

@export var speed = 120.0

@onready var sprite_base = $BaseSprite as AnimatedSprite2D
@onready var state_cache = {
	PlayerState.Type.IDLE: PlayerStateIdle.new(self),
	PlayerState.Type.RUNNING: PlayerStateRunning.new(self),
	PlayerState.Type.ROLLING: PlayerStateRolling.new(self)
}

var current_state_key = PlayerState.Type.IDLE
var current_state: PlayerState:
	get:
		return state_cache[current_state_key]

func _ready() -> void:
	assert(sprite_base != null)
	sprite_base.play()

func _physics_process(delta) -> void:
	# Get input
	var input_vector = Input.get_vector("left", "right", "up", "down")
	
	# Handle state
	var new_state_key = current_state.handle(input_vector, delta)
	if new_state_key != current_state_key:
		var args := {}

		match new_state_key:
			PlayerState.Type.ROLLING:
				args = {"direction": input_vector}

		change_state(new_state_key, args)

	# Move
	move_and_slide()

func change_state(new_state_key: PlayerState.Type, args := {}) -> void:
	current_state_key = new_state_key
	current_state.enter(args)
