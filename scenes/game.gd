extends Node2D

var dungeon = {
	'level-1' : {
		'name'  : 'level-1',
		'save'  : 'user://level-1.json',
		'scene' : 'res://scenes/room.tscn',
		'new'   : true,
		'spawn' : Vector2(1, 1),
		'links' : {
			Vector2(5, -14) : {
				'level' : 'level-2',
				'spawn' : Vector2(1, 1)
			},
			Vector2(4, 0) : {
				'level' : 'bonus-1-1',
				'spawn' : null
			}
		}
	},
	'level-2' : {
		'name'  : 'level-2',
		'save'  : 'user://level-2.json',
		'scene' : 'res://levels/Level2.tscn',
		'new'   : true,
		'spawn' : Vector2(2, 1),
		'links' : {
			Vector2(2, 1) : {
				'level' : 'level-1',
				'spawn' : Vector2(4, -14),
			}
		}
	},
	'bonus-1-1' : {
		'name'  : 'bonus-1-1',
		'save'  : 'user://bonus-1-1.json',
		'scene' : 'res://scenes/SokobanBonus/SokobanBonus.tscn',
		'new'   : true,
		'spawn' : Vector2(8, 8)
	}
}

var level_name = ''
var level = null
var level_last = {}

func _ready():
	randomize()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Ambient.play()
	level_change('level-2', null)

func _process(delta):
	$CanvasLayer2/Cursor/Sprite2D.position = get_global_mouse_position() - get_node("/root/game/Camera3D").position
	
func get_level():
	return self.level
	
func _unhandled_input(event):
	if event.is_action_pressed("reload"):
		get_viewport().set_input_as_handled()
		reload_level()
			
func reload_level():
	# TODO: probably need to cleanup children first.
	# TODO: find a better solution to this node naming/save issue
	# level.queue_free()
	# load_level(false)
	pass
	
func portal_enter(t):
	if t in dungeon[level_name]['links']:
		var link = dungeon[level_name]['links'][t]
		level_change(link['level'], link['spawn'])
	
func level_enter(name, spawn):
	level_name = name
	var scene = dungeon[name]['scene']
	scene = load(scene)
	level = load(dungeon[name]['scene']).instantiate()
	$LevelContainer.add_child(level, false)
	level.set_owner($LevelContainer)
	self.level = level
	level.init(dungeon[name])
	if not spawn:
		spawn = dungeon[name]['spawn']
	$Player.set_level(level, spawn)
	dungeon[name]['new'] = false
	
func level_exit():
	level.save(dungeon[level_name]['save'])
	level.queue_free()
	level_last = {
		'name' : level_name,
		'spawn' : $Player.position / 8,
	}
	
func level_change(name, spawn):
	if level:
		if name == 'last':
			name = level_last['name']
			spawn = level_last['spawn']
		level_exit()
	level_enter(name, spawn)
