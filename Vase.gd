extends Node2D

@onready var Event = get_node("/root/Events")
@onready var Utils = get_node("/root/Utils")

var gametype = 'vase'
var filled = true

func _ready():
	$Sprite2D.frame = 1
	pass

func init(d : Dictionary):
	position = d['position']

func is_solid():
	return true
		
func event(e):
	match e['type']:
		Event.BUMP:
			Utils.bump_tween_create(self, position, e['dir'])
		Event.INTERACT:
			if filled:
				$TreasureGrab.play()
				$Sprite2D.frame = 0
				filled = false
