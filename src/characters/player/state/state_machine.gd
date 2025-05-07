class_name PlayerStateMachine

enum State {
	IDLE,
	RUN,
	ROLL,
	JUMP,
	ATTACK
}

var states: Dictionary = {}
var current_state: PlayerState

func _init(player_: Player) -> void:
	states = {
		State.IDLE: PlayerIdleState.new(player_, self),
		State.RUN: PlayerRunState.new(player_, self),
		State.ROLL: PlayerRollState.new(player_, self),
		State.JUMP: PlayerStateJump.new(player_, self),
		State.ATTACK: PlayerStateAttack.new(player_, self)
	}
	
	transition_to(State.IDLE)

func transition_to(new_state: State) -> void:
	assert(new_state in states, "state '%s' not found" % State.keys()[new_state])
	
	if current_state:
		current_state.exit()
	
	current_state = states[new_state]
	current_state.enter()

func execute(delta: float) -> void:
	if current_state:
		current_state.execute(delta)
