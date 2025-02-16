extends Node2D

@onready var Items = get_node("/root/Items")
@onready var Event = get_node("/root/Events")

var gametype = ""

func init(d : Dictionary):
	gametype = d['gametype']
	$Sprite2D.texture = d['texture']
	position = d['position']

func is_solid():
	return false

func save(d):
	d['filename']   = get_scene_file_path()
	d['item']       = gametype
	d['parent']     = get_parent().get_path()
	d['position.x'] = position.x
	d['position.y'] = position.y

func load(d):
	position.x = d['position.x']
	position.y = d['position.y']
	gametype = d['item']
	$Sprite2D.texture = load(Items.ITEMS[gametype]['texture-image'])

func event(e):
	if e['type'] == Event.TAKEN:
		visible = false
		position = Vector2i(0, 0)
	elif e['type'] == Event.DROPPED:
		visible = true
		position = e['position']
