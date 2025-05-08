class_name PlayerState

var player: Player;
var state_machine: PlayerStateMachine

func _init(player_: Player, state_machine_: PlayerStateMachine) -> void:
	player = player_
	state_machine = state_machine_

func enter() -> void:
	pass

func exit() -> void:
	pass

func execute(_delta: float) -> void:
	assert(false, "execute function should be implemented")
	pass
