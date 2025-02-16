extends Node2D

var gametype = 'crate'

func init(d : Dictionary):
	position = d['position']

func is_solid():
	return true
	
func push(dir: Vector2i):
	var level = get_parent()
	var t = level.world_to_tile(position)
	print("initial position %d,%d tile %d,%d" % [position.x, position.y, t.x, t.y])
	if level.is_solid(t + dir):
		return false
	level.remove_node_from_tile('obj', t, self)
	t += dir
	level.add_node_to_tile('obj', t, self)
	position = level.tile_to_world(t)
	print("final position %d,%d tile %d,%d" % [position.x, position.y, t.x, t.y])
	return true
