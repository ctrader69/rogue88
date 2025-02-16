extends ActionLeaf

var wait = 0 
@export var wait_n_turns = 3

func tick(actor: Node, blackboard: Blackboard):
	wait += 1
	if wait >= wait_n_turns:
		wait = 0
		return SUCCESS
	return RUNNING
