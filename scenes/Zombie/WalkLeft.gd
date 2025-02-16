extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var left = Vector2i(-1, 0)
	actor.facing = left
	if actor.move(left):
		return RUNNING
	return SUCCESS
