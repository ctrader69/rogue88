extends BeehaveTree

var turn = false

func _physics_process(delta: float) -> void:
	if turn:
		super._physics_process(delta)
		turn = false
		
func on_turn():
	turn = true
