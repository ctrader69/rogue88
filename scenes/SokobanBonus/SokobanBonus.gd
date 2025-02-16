extends "res://LevelBase.gd"

# TODO: item populate
# TODO: exit handling (currently in player)
# TODO: exit dialog
# TODO: help dialog
# TODO: character/ghost who owns the puzzle?
# TODO: glowing magic symbols
# TODO: either get save working or de-activate portal on exit
# TODO: difficulty levels (change color scheme)
# TODO: make torch color match level
# TODO: background music
# TODO: other sound effects (torch on/off)
# TODO: move this torch to base game (or create base class)
# TODO: background animation?
# TODO: box slide animation

var torches = {}
var runes = {}
var crates = {}
var chest = null
var solved = false

func _ready():
	CELLDATA = {
		'base' : {
			1 : {
				'name'  : 'void',
				'solid' : true,
			},
			2 : {
				'name'  : 'floor',
				'solid' : false,
			},
			3 : {
				'name'  : 'wall',
				'solid' : true,
			},
		},
		'obj' : {
			
		},
		'enemy' : {
		},
	}

	objs.OBJDATA = {
		'crate' : {
			'scene'    : preload("res://scenes/Crate/Crate.tscn"),
			'solid'    : true,
			'pushable' : true,
		},
		'chest' : {
			'scene'    : preload("res://scenes/SokobanBonus/Chest.tscn"),
			'solid'    : true,
			'pushable' : false,
		},
		'torch' : {
			'scene'    : preload("res://scenes/SokobanBonus/Torch.tscn"),
			'solid'    : true,
			'pushable' : false,
		},
		'rune-1' : {
			'scene'    : preload("res://scenes/SokobanBonus/Rune.tscn"),
			'solid'    : false,
			'pushable' : false,
		},
	}
	EventBus.connect("player_turn", Callable(self, "on_turn"))
	var scene = preload("res://MessageBar/MessageBar.tscn").instantiate()
	add_child(scene)
	scene.play('Bonus!', 16, Color('#ac3232'), Color('#ffffff'))
	
func cell_is_rune(cell):
	return CELLDATA['obj'][cell].name.match('rune-*')
		
func nodes_created():
	for n in get_children():
		if 'gametype' in n:
			var t = world_to_tile(n.position)
			match n.gametype:
				'torch':
					torches[t] = n
				'rune':
					runes[t] = n
				'chest':
					chest = n

	for t1 in runes:
		var rune = runes[t1]
		for t2 in torches:
			var torch = torches[t2]
			if not torch.rune:
				rune.torch = torch
				torch.rune = rune
				break
		if rune.torch:
			break

func on_turn():
	for t in runes:
		var rune = runes[t]
		if get_node_at_tile('obj', t):
			rune.covered_set(true)
		else:
			rune.covered_set(false)
	
	if solved:
		return
	
	solved = true
	for t in torches:
		var torch = torches[t]
		if torch.lit:
			solved = false
			break
	if solved:
		print('solved')
		# TODO: remove invisible effect from chest
