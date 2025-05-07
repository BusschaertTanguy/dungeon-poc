class_name Player
extends CharacterBody2D

@export var speed = 120.0
@onready var sprite_controller := $SpriteController as SpriteController
@onready var state_machine := PlayerStateMachine.new(self)

func _ready() -> void:
	assert(sprite_controller != null)
	assert(state_machine != null)

func _physics_process(delta) -> void:
	state_machine.execute(delta)
