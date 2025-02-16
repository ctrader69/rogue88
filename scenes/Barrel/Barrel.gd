extends Node2D

@onready var Event = get_node("/root/Events")
@onready var Util = get_node("/root/Utils")

var gametype = 'barrel'
var contents = ''

func init(d : Dictionary):
	position = d['position']

func is_solid():
	return true
	
func _ready():
	$Liquid/AnimationPlayer.play('slosh')
	
func event(e):
	match e['type']:
		Event.BUMP:
			Util.bump_tween_create(self, position, e['dir'])
