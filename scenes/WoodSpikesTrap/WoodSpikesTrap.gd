extends Node2D

var gametype = 'wood-spikes-trap'
var sprung = false

@onready var EventBus = get_node("/root/EventBus")
	
func _ready():
	set_frame()
	EventBus.connect("tile_entered", Callable(self, "on_tile_entered"))
	
func init(d : Dictionary):
	position = d['position']
	
func is_solid():
	return false
	
func save(d):
	d['filename']   = get_scene_file_path()
	d['sprung']     = sprung
	d['parent']     = get_parent().get_path()
	d['position.x'] = position.x
	d['position.y'] = position.y
	
func load(d: Dictionary):
	sprung = d['sprung']
	position.x = d['position.x']
	position.y = d['position.y']
	set_frame()
	
func set_frame():
	if sprung:
		$Sprite2D.frame = 1
	else:
		$Sprite2D.frame = 0
		
func on_tile_entered(t, n):
	if t == get_parent().world_to_tile(position):
		if n.gametype == 'lifeform' or n.gametype == 'zombie':
			sprung = true
			EventBus.disconnect('tile_entered', Callable(self, 'on_tile_entered'))
			set_frame()
			n.add_child(preload("res://scenes/HeadLabel/HeadLabel.tscn").instantiate().init(str(-1), Vector2(0, -4), Color('#ff004d'), Color('#7e2553')))
			
func event(_e):
	pass
