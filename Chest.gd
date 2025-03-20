extends Node2D

@onready var Event = get_node("/root/Events")
@onready var Utils = get_node("/root/Utils")
@onready var game = get_node("/root/game")

var gametype = 'chest'
var state = 'closed'
var locked_state = 'unlocked'
var nabbed = false

var container = null

func _ready():
	# register callback with container
	# apis - is_empty()
	#      - add/remove
	#      - communicate what was selected when check was pressed
	#      - 'e' - open, then 'e' to view
	#      - center container on screen
	#      - disable normal input
	pass
	
func init(d : Dictionary):
	container = preload("res://scenes/Container/container.tscn").instantiate()
	container.init()
	position = d['position']
	if 'contents' in d:
		for item in d['contents']:
			# TODO: bow-wooden -> bow
			# e.g. {'gametype' : 'bow', 'initdata' : {}}
			var gt = item['gametype']
			if gt in OBJ.DATA:
				var n = OBJ.DATA[gt].scene.instantiate()
				var initdata = OBJ.DATA[gt].init
				# TODO: not working
				# initdata.merge(item[initdata])
				n.init(initdata)
				container.add(n)

func is_solid():
	return true

func state_set(new_state):
	var old_state = state
	
	if old_state == new_state:
		return

	state = new_state
	
	if state == 'closed':
		$ChestClose.play()
		$Sprite2D.frame = 0
	elif state == 'open':
		game.add_child(container)
		container.set_owner(game)
		if nabbed:
			$Sprite2D.frame = 1
			$ChestOpen.play()
		else:
			$Sprite2D.frame = 2
			$ChestSuccess.play()
	
func event(e):
	match e['type']:
		Event.INTERACT:
			if state == 'closed':
				event(Event.make(Event.OPEN, e['src']))
			elif state == 'open':
				if nabbed:
					event(Event.make(Event.CLOSE, e['src']))
				else:
					nabbed = true
					$Sprite2D.frame = 1
					$Nabbed.play()
		Event.OPEN:
			state_set('open')
		Event.CLOSE:
			state_set('closed')
		Event.BUMP:
			Utils.bump_tween_create(self, position, e['dir'])
