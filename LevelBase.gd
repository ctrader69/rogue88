extends Node2D

@onready var Base = get_node("/root/Base")
@onready var Items = get_node("/root/Items")
@onready var EventBus = get_node("/root/EventBus")



var description = {}

var astar = null
var astar_rect = null
var astar_debug_enable = false
var astar_debug_node = null

# areas/regions
#
# areas {
#   [N] : {
#     'hidden' : true|false,
#     'tiles' : [Vector2i(x,y), ... Vector2i(x,y)],
#   }
# }
#
# areas_tile_to_area_id
var areas = {}
var areas_tile_to_area = {}

# assume a TileMap called 'base' always exists
func get_base():
	return $base
	
func exit_room(r: Vector2):
	print("LevelBase::exiting_room [%d,%d]" % [r.x, r.y])
	
func enter_room(r: Vector2):
	print("LevelBase::entering_room [%d,%d]" % [r.x, r.y])
	
var nodes = {
	'base' : {
	},
	'obj' : {
	},
}
var mapdata = {}

func world_to_tile(w: Vector2):
	# GODOT_4 - map_to_local not working
	# return Vector2i(get_node("./obj").local_to_map(w))
	# TODO TILESIZE
	return Vector2i(w / 8)
	
func tile_to_world(t: Vector2i):
	# GODOT_4 - map_to_local not working
	# return Vector2(get_node("./obj").map_to_local(t))
	# TODO TILESIZE
	return Vector2(t * 8)

func get_nodes_at_tile(layer : String, t: Vector2i):
	if t in nodes[layer]:
		return nodes[layer][t] 
	return []

func add_node_to_tile(layer: String, t: Vector2i, n):
	if not nodes[layer].has(t):
		nodes[layer][t] = []
	nodes[layer][t].append(n)
   # experiment
	add_child(n)
	n.set_owner(self)
	if n.is_solid():
		astar_tile_disable(t)
	EventBus.emit_signal('tile_entered', t, n)
	
func remove_node_from_tile(layer : String, t: Vector2i, n):
	if not nodes[layer].has(t):
		return
	var i = nodes[layer][t].find(n)
	if i < 0:
		return
	nodes[layer][t].remove_at(i)
	if n.is_solid():
		astar_tile_enable(t)

func nodes_from_tiles(create: bool):
	var tileset = $obj.tile_set
	for t in $obj.get_used_cells():
		if not create:
			$obj.set_cell(t, -1)
			continue
		var name = $obj.get_cell_tile_data(t).get_custom_data("name")
		if name in OBJ.DATA.keys():
			if 'scene' in OBJ.DATA[name].keys():
				$obj.set_cell(t, -1)
				var scene = OBJ.DATA[name]['scene']
				var n = scene.instantiate()
				add_child(n, false)
				n.set_owner(self)
				var initdata = {}
				if 'init' in OBJ.DATA[name].keys():
					for key in OBJ.DATA[name]['init']:
						initdata[key] = OBJ.DATA[name]['init'][key]
				initdata['position'] = t * 8
				if mapdata.has(t):
					for key in mapdata[t].keys():
						initdata[key] = mapdata[t][key]
				n.init(initdata)
				add_node_to_tile('obj', t, n)
#
#	var layer = 'enemy'
#	for t in $enemy.get_used_cells():
#		var c = $enemy.get_cell(t.x, t.y)
#		var name = CELLDATA['enemy'][c].name
#		if name == 'bat':
#			$enemy.set_cell(t.x, t.y, -1)
#			if create:
#				var n = CELLDATA[layer][c].scene.instantiate()
#				n.set_owner(self)
#				add_child(n, false)
#				n.init(t)
#				set_node_at_tile('obj', t, n)
#		if name == 'zombie':
#			$enemy.set_cell(t.x, t.y, -1)
#			if create:
#				var n = CELLDATA[layer][c].scene.instantiate()
#				n.set_owner(self)
#				add_child(n, false)
#				n.init(t)
#				set_node_at_tile('obj', t, n)
#		if name == 'poisonous-frog':
#			$enemy.set_cell(t.x, t.y, -1)
#			if create:
#				var n = CELLDATA[layer][c].scene.instantiate()
#				n.set_owner(self)
#				add_child(n, false)
#				n.init(t)
#				set_node_at_tile('obj', t, n)
#		if name == 'rat':
#			$enemy.set_cell(t.x, t.y, -1)
#			if create:
#				var n = CELLDATA[layer][c].scene.instantiate()
#				n.set_owner(self)
#				add_child(n, false)
#				n.init(t)
#				set_node_at_tile('obj', t, n)
#		if name == 'barkeep':
#			$enemy.set_cell(t.x, t.y, -1)
#			if create:
#				var n = Mobs.MOBS[name].scene.instantiate()
#				n.set_owner(self)
#				add_child(n, false)
#				n.init(t)
#				set_node_at_tile('obj', t, n)

func nodes_created():
	pass
	
func _on_tile_entered(t, who): 
	# TODO: create a map of tile to hidden areas.
	# TODO: ok, this works but only one cell
	#   - need to quickly map a t -> area where are is the area id
	#   - need to map area -> list of tiles that belong to that area
	#   - then I can make visible all tiles in this area.
	if areas_tile_to_area.has(t):
		var area = areas_tile_to_area[t]
		if not areas[area]['visible']:
			areas_toggle_visibility(area)

# areas_ todo: an object in an area is making the whole are visible ... why
func areas_init():
	# TODO: fade-in?  replace tile with one that has a shader.  This shader can increase visibility.
	for t in $areas.get_used_cells():
		var tiledata = $areas.get_cell_tile_data(t)
		var area = tiledata.get_custom_data("id")
		if not areas.has(area):
			print("area %d discovered" % area)
			areas[area] = {
				'visible' : true,
				'tiles' : []
			}
		areas[area]['tiles'].append(t)
		areas_tile_to_area[t] = area

	for area in areas:
		areas_toggle_visibility(area)
		
func areas_toggle_visibility(area):
	if not areas.has(area):
		return
	var was_visible = areas[area]['visible']
	var now_visible = not was_visible
	areas[area]['visible'] = now_visible
	print("area %d visible change" % area)
	for t in areas[area]['tiles']:
		if now_visible:
			$visibility.erase_cell(t)
		else:
			$visibility.set_cell(t, 1, Vector2i(0, 0))
		
func _ready():
	EventBus.connect("tile_entered", Callable(self, "_on_tile_entered"))
	#EventBus.connect("tile_entered", Callable(self, "on_turn"))
	areas_init()
	
func astar_debug():
	if astar_debug_enable:
		if astar_debug_node:
			astar_debug_node.queue_free()
		astar_debug_node = Node2D.new()
		add_child(astar_debug_node)
		var src = astar_point_id(world_to_tile(get_node("../../Player").position))
		var dst = astar_point_id(Vector2(11, -14))
		var points = astar.get_point_path(src, dst)
		if points and len(points) > 0:
			for point in points:
				var n = ColorRect.new()
				n.position = tile_to_world(point)
				n.size = Vector2(8, 8)
				n.color = Color(1.0, 0.0, 0.0, 0.1)
				astar_debug_node.add_child(n)
				
func astar_tile_enable(t: Vector2):
	astar.set_point_disabled(astar_point_id(t), false)
	
func astar_tile_disable(t: Vector2):
	astar.set_point_disabled(astar_point_id(t), true)
	
func astar_point_id(t: Vector2):
	return ((t.y - astar_rect.position.y) * astar_rect.size.x) + (t.x - astar_rect.position.x)

func astar_init():
	astar_rect = $base.get_used_rect()
	astar = AStar2D.new()
	# GODOT_4
	#for t in $base.get_used_cells(0):
	#	var c = $base.get_cell(t.x, t.y)
	#	if not CELLDATA["base"][c].solid:
	#		var id = astar_point_id(t)
	#		astar.add_point(id, t)
	#		for dir in Base.DIRS:
	#			var neighbor_t = t + dir
	#			var neighbor_id = astar_point_id(neighbor_t)
	#			if astar.has_point(neighbor_id):
	#				astar.connect_points(id, neighbor_id, true)

func init(description):
	self.description = description
	astar_init()
	if description['new']:
		nodes_from_tiles(true)
		pass
	else:
		nodes_from_tiles(false)
		init_from_file(description['save'])
		pass
	nodes_created()
	
func layer_to_node(layer: String):
	if layer == "base":
		return $base
	elif layer == "obj":
		return $obj
	elif layer == "enemy":
		return $enemy
	else:
		return null

func is_solid(t : Vector2i):
	for layer in ["base"]:
		var node = layer_to_node(layer)
		var tiledata = node.get_cell_tile_data(t)
		if tiledata:
			if tiledata.get_custom_data("solid"):
				return true
	for layer in ["obj"]:
		var node = layer_to_node(layer)
		var tiledata = node.get_cell_tile_data(t)
		if tiledata:
			if tiledata.get_custom_data("solid"):
				return true
	if nodes['obj'].has(t):
		for n in nodes['obj'][t]:
			if n.is_solid():
				return true
	return false
	
func is_empty(t):
	for layer in [0, 1]:
		var tiledata = $obj.get_cell_tile_data(0, t)
		if tiledata:
			if tiledata.get_custom_data("solid"):
				return false
	if get_nodes_at_tile('obj', t).size() > 0:
		return false
	return true

# is the tile a portal (e.g. staircase, etc) to another level
# Put this in the tilemap data structure
func is_portal(t):
	return false
	var layer = layer_to_node('obj')
	var cell = layer.get_cell(t.x, t.y)
	if cell >= 0:
		match layer.tile_set.tile_get_name(cell):
			'staircase-up','staircase-down':
				return true

	var N = get_nodes_at_tile('obj', t)
	if N:
		for n in N:
			if n and n.gametype == 'portal':
				return true
	return false
		
func portal_entry_allowed(t, dir):
	var tilemap = layer_to_node('obj')
	var cell = tilemap.get_cell(t.x, t.y)
	if cell >= 0:
		match tilemap.tile_set.tile_get_name(cell):
			'staircase-up','staircase-down':
				if dir == Base.RIGHT:
					return true
					
	for n in get_nodes_at_tile('obj', t):
		if n and n.gametype == 'portal' and dir == Base.UP:
			return true
	return false

func event(e, t: Vector2i):
	if e == 'get':
		for n in get_nodes_at_tile('obj', t):
			if n:
				remove_node_from_tile('obj', t, n)
				remove_child(n)
				return n
		
func save(filename):
	print("room::save")
	var f = FileAccess.open(filename, FileAccess.WRITE)
	var d = {
		'filename' : get_scene_file_path(),
		'parent' : get_parent().get_path(),
		'children' : []
	}
	for key in nodes['obj']:
		var n = nodes['obj'][key]
		if n.filename.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % n.name)
			continue
		if !n.has_method("save"):
			# print("persistent node '%s' is missing a save() function, skipped" % n.name)
			continue
		var child_data = {}
		n.save(child_data)
		d['children'].append(child_data)
	f.store_line(JSON.new().stringify(d))
	f.close()
	print("room::save_all complete")
	
func init_from_file(filename):
	print("load: %s" % get_path())
	if not FileAccess.file_exists(filename):
		print("file %s does not exist", filename)
		return
	var f = FileAccess.open(filename, FileAccess.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse(f.get_line())
	var d = test_json_conv.get_data()
	f.close()
	for child in d['children']:
		print("child")
		var n = load(child['filename']).instantiate()
		add_child(n, false)
		n.set_owner(self)
		n.load(child)
		add_node_to_tile('obj', $base.local_to_map(n.position), n)
		
func _process(delta):
	astar_debug()
	
func floor_domain_get_walk(t, cellname, map):
	for dir in Base.DIRS:
		var target = t + dir
		if not target in map:
			var target_cellname = ($base.tile_set).tile_get_name($base.get_cell(target.x, target.y))
			if target_cellname == cellname:
				map[target] = true
				floor_domain_get_walk(target, cellname, map)
			else:
				map[target] = false
			
func floor_domain_get(t):
	var map = {}
	var cellname = ($base.tile_set).tile_get_name($base.get_cell(t.x, t.y))
	map[t] = true
	floor_domain_get_walk(t, cellname, map)
	for t2 in map.keys():
		if not map[t2]:
			map.erase(t2)
	return map

func find_tile_for_drop(src: Vector2i):
	# TODO: start at facing direction
	# TODO: diagonals too (might make object unreachable)
	if is_empty(src):
		return src
	var dirs = [
		Vector2i(1, 0),
		Vector2i(1, 1),
		Vector2i(-1, 0),
		Vector2i(0, -1)
	]
	for dir in dirs:
		var dst = src + dir
		if is_empty(dst):
			return dst
	return null
