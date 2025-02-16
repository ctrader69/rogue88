extends ActionLeaf

@onready var Event = get_node("/root/Events")

@export var dir : Vector2i = Vector2i(1, 0)

func tick(actor: Node, blackboard: Blackboard):
	var level = actor.get_parent()
	var src = Vector2i(actor.position / 8)
	var dst = Vector2i(src + dir)
	if not level.is_solid(dst):
		actor.move(dir)
		return RUNNING
	else:
		for n in level.get_nodes_at_tile('obj', dst):
			if n and n.gametype == 'door':
				var e = Event.make(Event.BUMP, actor)
				e['dir'] = dir
				n.event(e)
				return RUNNING
	return SUCCESS
