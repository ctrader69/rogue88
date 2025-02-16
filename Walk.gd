extends ActionLeaf
@export var dir : Vector2i = Vector2i(1, 0)
func tick(actor: Node, blackboard: Blackboard):
	actor.facing = dir
	if actor.move(dir):
		return RUNNING
	return SUCCESS
