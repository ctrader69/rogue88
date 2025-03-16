extends Node2D

@onready var level = get_parent()
@onready var Event = get_node("/root/Events")
@onready var Util = get_node("/root/Utils")
@onready var text_layer = get_node("/root/game/CanvasLayer2")

var hp = 25
var gametype = 'door'
var open = false
var locked = false
var dir = 'down'
var busted = false

func _ready():
	pass
	
func init(d: Dictionary):
	self.position = d['position']
	self.locked = d['locked']
	self.dir = d['dir']
	self.hp = d['hp'] if d.has('hp') else self.hp
	set_frame()
	update_pathfinding()
	
func save(d : Dictionary):
	d['dir']          = dir
	d['filename']     = get_scene_file_path()
	d['hp']           = hp
	d['locked']       = locked
	d['open']         = open
	d['parent']       = get_parent().get_path()
	d['position.x']   = position.x
	d['position.y']   = position.y
	d['Sprite2D.frame'] = $Sprite2D.frame
	
func load(d: Dictionary):
	dir = d['dir']
	position.x = d['position.x']
	position.y = d['position.y']
	open = d['open']
	locked = d['locked']
	set_frame()
	update_pathfinding()
	
func is_solid():
	return not open and not busted
	
func set_frame():
	if dir == 'left':
		if open:
			$Sprite2D.frame = 6
			$Sprite2D.offset = Vector2(0, -6)
		else:
			$Sprite2D.frame = 5
			$Sprite2D.offset = Vector2(-1, 0)
	elif dir == 'down':
		if open:
			$Sprite2D.frame = 1
			$Sprite2D.offset = Vector2(0, 0)
		else:
			$Sprite2D.frame = 0
			$Sprite2D.offset = Vector2(0, 0)
	elif dir == 'right': 
		if open:
			$Sprite2D.frame = 4
			$Sprite2D.offset = Vector2(0, -6)
		else :
			$Sprite2D.frame = 3
			$Sprite2D.offset = Vector2(1, 0)
			
func update_pathfinding():
	if open:
		level.astar_tile_enable(level.world_to_tile(position))
	else:
		level.astar_tile_disable(level.world_to_tile(position))
	
func event(e):
	if busted:
		return
	match e['type']:
		Event.INTERACT:
			if not open and not locked:
				event(Event.make(Event.OPEN, self))
			elif open:
				event(Event.make(Event.CLOSE, self))
		Event.OPEN:
			open = true
			set_frame()
			$DoorClose.play()
			update_pathfinding()
		Event.CLOSE:
			open = false
			set_frame()
			$DoorClose.play()
			update_pathfinding()
		Event.BUMP:
			Util.bump_tween_create(self, position, e['dir'])
			var damage = -1
			hp += -1
			# TODO: this is repeated, perhaps have a damage 'component'
			text_layer.add_child(preload("res://scenes/HeadLabel/HeadLabel.tscn").instantiate().init(str(damage), position + Vector2(0, -4), Color('#ff004d'), Color('#7e2553')))
			$DoorHit.play()
			if hp <= 0:
				busted = true
				$Sprite2D.frame = 7
				$DoorBusted.play()
