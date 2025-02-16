extends Node2D

@onready var Event = get_node("/root/Events")
@onready var Util = get_node("/root/Utils")

var gametype = 'bookshelf'

func init(d : Dictionary):
	position = d['position']
	if d['full']:
		# TODO: pick random frame
		$Sprite2D.frame = 1
	else:
		$Sprite2D.frame = 0
		
func is_solid():
	return true

func event(e):
	match e['type']:
		Event.BUMP:
			Util.bump_tween_create(self, position, e['dir'])
