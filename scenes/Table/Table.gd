extends Node2D

@onready var Event = get_node("/root/Events")
@onready var Utils = get_node("/root/Utils")

var gametype = 'table'
var contents = []

func init(d : Dictionary):
	position = d['position']
	
	# Spawn drinks unconditionally for now.
	for base in [$DrinkPositionTopLeft, $DrinkPositionBottomRight]:
		var n = preload("res://scenes/Drink/Drink.tscn").instantiate()
		add_child(n)
		n.init(
			{
				'position' : base.position - Vector2(n.WIDTH / 2, n.HEIGHT),
			}
		)
		contents.append(n)
		

func is_solid():
	return true
	
func event(e):
	if e['type'] == Event.BUMP:
		Utils.bump_tween_create(self, position, e['dir'])
		for n in contents:
			n.event(e)
