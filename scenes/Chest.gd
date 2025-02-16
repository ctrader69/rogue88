extends Node2D

var gametype = 'chest'
var state = 'closed'
var locked_state = 'unlocked'
var nabbed = false

func _ready():
	pass
	
func init(d : Dictionary):
	position = d['position']
	
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
		if nabbed:
			$Sprite2D.frame = 1
			$ChestOpen.play()
		else:
			$Sprite2D.frame = 2
			$ChestSuccess.play()
	
func event(event):
	if event == 'interact':
		if state == 'closed':
			event('open')
		elif state == 'open':
			if nabbed:
				event('close')
			else:
				event('nab')
	elif event == 'open':
		state_set('open')
	elif event == 'close':
		state_set('closed')
	elif event == 'nab':
		nabbed = true
		$Sprite2D.frame = 1
		$Nabbed.play()
