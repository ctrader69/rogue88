extends Node2D

@onready var Event = get_node("/root/Events")
var gametype = 'fireplace'
var contents = 'firewood'
var lit = false
var perpetual = false

func is_solid():
	return true
	
func unit_test():
	event({
		'type' : Event.IGNITE,
	})
	
func _ready():
	$Sprite2D.frame = 0
	$Flames.emitting = false
	#unit_test()
	
func init(d : Dictionary):
	position = d['position']
	if d['lit']:
		perpetual = true
		event(Event.make(Event.LOAD, self))
		event(Event.make(Event.IGNITE, self))

func event(e):
	match e['type']:
		Event.IGNITE:
			lit = true
			$Flames.emitting = true
			if not perpetual:
				$FlameTmr.start()
		Event.INTERACT:
			if contents == '' and e['src'].has_item('firewood'):
				e['src'].remove_item('firewood')
				event(Event.make(Event.LOAD, e['src']))
			elif contents == 'firewood' and not lit:
				# TODO: require flint/steel
				event(Event.make(Event.IGNITE, e['src']))
			elif contents == 'charcoal':
				e['src'].add_item(contents)
				contents = ''
				$Sprite2D.frame = 0
		Event.LOAD:
			contents = 'firewood'
			$Sprite2D.frame = 1

func _on_FlameTmr_timeout():
	$Flames.emitting = false
	$Sprite2D.frame = 2
	contents = 'charcoal'
	lit = false
