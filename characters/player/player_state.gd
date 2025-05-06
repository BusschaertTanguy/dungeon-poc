class_name PlayerState
extends Object

enum Type {
	IDLE,
	RUNNING,
	ROLLING
}

var player: Player;

func _init(player_: Player) -> void:
	player = player_

func enter(_args := {}) -> void:
	pass

func handle(_direction: Vector2, _delta: float) -> Type:
	return Type.IDLE
