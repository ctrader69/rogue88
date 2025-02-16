extends Node2D

# TODO: move this to the base scenes
var gametype = 'chest'
var items = []

var locked = true
var m_open = false

func ready():
	pass

func init(d: Dictionary):
	self.position = d['position']
	self.position += Vector2(0.5, 0.5)
	locked = true
	$Sprite2D.frame = 0
	$Glow.visible = false
	items.append('oink')

func is_solid():
	return true
	
func unlock():
	locked = false
	
func open():
	if not m_open:
		if len(items) > 0:
			$Sprite2D.frame = 1
			$Glow.visible = true
		else:
			$Sprite2D.frame = 2
		m_open = true
	
func close():
	if open:
		$Sprite2D.frame = 0
		m_open = false
		$Glow.visible = false
	
func event(e):
	if e == 'interact':
		if locked:
			return
		if open:
			if len(items) > 0:
				event('get')
			else:
				event('close')
		else:
			if locked:
				return
			else:
				event('open')
	elif e == 'open':
		open()
	elif e == 'close':
		close()
	elif e == 'get':
		items = []
		$Glow.visible = false
		$Sprite2D.frame = 2
