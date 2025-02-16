extends Node2D

@onready var level = get_node('../')
@onready var Event = get_node('/root/Events')

const SECTIONS = {
	'top-left' : {
		'frame' : 0,
	},
	'middle-left' : {
		'frame' : 1,
	},
	'bottom-left' : {
		'frame' : 2,
	},
	'bottom-middle' : {
		'frame' : 4,
	},
	'bottom-door' :  {
		'frame' : 3,
	},
	'bottom-right' : {
		'frame' : 5,
	},
	'middle-right' : {
		'frame' : 6,
	},
	'top-right' : {
		'frame' : 7,
	},
	'bottom-door-open' : {
		'frame' : 8,
	}
}

var gametype = 'bartop'
var section = ''
var door_closed = true

func init(d: Dictionary):
	position = d['position']
	section_set(d['section'])
	
func is_solid():
	if section == 'bottom-door' and not door_closed:
		return false
	return true

func section_set(section):
	self.section = section
	$Sprite2D.frame = SECTIONS[section].frame
	
func door_close():
	door_closed = true
	$Sprite2D.frame = SECTIONS[section].frame
	$CloseSfx.play()
	level.astar_tile_disable(level.world_to_tile(position))
	
func door_open():
	door_closed = false
	$Sprite2D.frame = 8
	$OpenSfx.play()
	level.astar_tile_enable(level.world_to_tile(position))
	
func event(e):
	if e['type'] == Event.INTERACT:
		if section == 'bottom-door':
			if door_closed:
				door_open()
			else:
				door_close()

func unit_test():
	init({
		'position' : Vector2(0, 0),
		'section' : 'bottom-door',
	})
	event({
		'type' : Event.INTERACT,
	})
	
func _ready():
	pass
	#unit_test()
