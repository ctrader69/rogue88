extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var right = Vector2i(1, 0)
	actor.facing = right
	if actor.move(right):
		return RUNNING
	return SUCCESS
