extends Node2D

var gametype = 'sign'
var my_hidden = true

@onready var label = get_node("CanvasLayer/NinePatchRect/Label")
@onready var Event = get_node("/root/Events")
@export var text : String = "All your base are belong to us!"

func _ready():
	$CanvasLayer.visible = false
	label.text = text
	
func is_solid():
	return false
	
func init(d: Dictionary):
	position = d['position']
	if d.has('text'):
		label.text = d['text']
		
func save(d : Dictionary):
	d['filename']   = get_scene_file_path()
	d['parent']     = get_parent().get_path()
	d['position.x'] = position.x
	d['position.y'] = position.y
	d['text']       = label.text
	
func load(d):
	position.x = d['position.x']
	position.y = d['position.y']
	label.text = d['text']
	
func event(e):
	match e['type']:
		Event.INTERACT:
			if my_hidden:
				my_hidden = false
				$CanvasLayer.visible = true
			else:
				my_hidden = true
				$CanvasLayer.visible = false
		Event.BUMP:
			var tw = create_tween()
			tw.set_trans(Tween.TRANS_QUINT)
			tw.set_ease(Tween.EASE_OUT)
			tw.tween_property(self, "position", position + (2 * e['dir']), 0.1)
			tw.chain()
			tw.tween_property(self, "position", position, 0.1)
