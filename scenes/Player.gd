extends "res://scenes/Lifeform.gd"

const TILESIZE = 8
const TILES_PER_ROOM = 16
const CAMERA_SHIFT = (TILES_PER_ROOM - 1) * TILESIZE
const ROOMSIZE = TILES_PER_ROOM * TILESIZE
const LEFT = Vector2i(-1, 0)
const RIGHT = Vector2i(1, 0)
const UP = Vector2i(0, -1)
const DOWN = Vector2i(0, 1)
const DIRS = [RIGHT, DOWN, LEFT, UP]

# dynamic references
var level : Node2D = null
var base : TileMapLayer = null

var weapon = null
var actions = []

# static references
@onready var game = get_node("/root/game")
@onready var camera : Camera2D = get_node("/root/game/Camera3D")
@onready var sfx = get_node("/root/game/Sfx")
@onready var Items = get_node("/root/Items")
@onready var player_status = get_node("/root/game/CanvasLayer2/PlayerStatus")
@onready var gui_layer = get_node("/root/game/CanvasLayer2")

# child references
@onready var inventory = $CanvasLayer/Inventory

func _ready():
	position = Vector2(1, 1) * TILESIZE
	$Gfx/Torso/AnimationPlayer.play("heave")
	#inventory.set_actor(self)
	$FlickeringLightSource.enable()
	
func set_level(level, spawn):
	self.level = level
	base = level.get_base()
	position = spawn * TILESIZE
	camera.position = Vector2(0, 0)
	if camera.position.x + CAMERA_SHIFT < position.x:
		while camera.position.x < position.x:
			camera.position.x += CAMERA_SHIFT
	elif camera.position.x > position.x:
		while camera.position.x > position.x:
			camera.position.x -= CAMERA_SHIFT
	if camera.position.y + CAMERA_SHIFT < position.y:
		while camera.position.y < position.y:
			camera.position.y += CAMERA_SHIFT
	elif camera.position.y > position.y:
		while camera.position.y > position.y:
			camera.position.y -= CAMERA_SHIFT
	level.enter_room(roomid_calc())
	
	# TODO: LEVELTYPE enum
	if level.description['scene'] == 'res://scenes/SokobanBonus/SokobanBonus.tscn':
		actions = [
			'get',
			'interact',
			'ui_w',
			'ui_a',
			'ui_s',
			'ui_d',
			'quit',
		]
	else:
		actions = [
			'fire',
			'get',
			'info',
			'interact',
			'inventory',
			'ui_w',
			'ui_a',
			'ui_s',
			'ui_d',
			'wait',
		]
	
func world_to_tile(p: Vector2):
	return base.local_to_map(p)
	
func tile_to_world(t: Vector2):
	return base.map_to_local(t)
	
func roomid_calc():
	return Vector2(
		camera.position.x / (TILES_PER_ROOM - 1) / TILESIZE,
		camera.position.y / (TILES_PER_ROOM - 1) / TILESIZE)
		
func face(v):
	if v == RIGHT:
		$Gfx/Torso.flip_h = false
		$Gfx/Legs.flip_h = false
		$Gfx/Shadow.position = Vector2(-0.5, 0.5)
	elif v == LEFT:
		$Gfx/Torso.flip_h = true
		$Gfx/Legs.flip_h = true
		$Gfx/Shadow.position = Vector2(0.5, 0.5)
		
func dump_room():
	var r = roomid_calc()
	print('room : %d,%d' % [r.x, r.y])
	
func bump(v):
	attack_animation(v)
	$BumpSfx.play()
	
func set_facing(v):
	facing = v
	if weapon:
		weapon.set_facing(v)
	
func move(v):
	# TODO: this should be higher - it's the keyboard click
	sfx.play()
	
	var t = base.local_to_map(position)
	var target = t + v
	if level.is_solid(target):
		if level.is_portal(target) and level.portal_entry_allowed(target, v):
			get_parent().portal_enter(target)
			# DO_NOT_COMMIT
			#if level.is_level_portan(staircase_up(t + v)
			#	get_parent().level_change(-1)
			#	return
			#elif level.is_staircase_down(t + v):
			#	get_parent().level_change(1)
			#	return
		else:
			bump(v)
	else:
		position += Vector2(v * TILESIZE)
		t += v
		EventBus.emit_signal("tile_entered", t, self)
	
	# TODO: enter/exit room - camera pan is a side-effect of this, hook up exit_room call.
	# pan camera
	# TOOD: implement exit/enter as events
	if v == RIGHT:
		if camera.position.x + CAMERA_SHIFT <= position.x:
			camera.position.x += CAMERA_SHIFT
			level.enter_room(roomid_calc())
	elif v == LEFT:
		if camera.position.x >= position.x:
			camera.position.x -= CAMERA_SHIFT
			level.enter_room(roomid_calc())
	elif v == UP:
		if camera.position.y >= position.y:
			camera.position.y -= CAMERA_SHIFT
			level.enter_room(roomid_calc())
	elif v == DOWN:
		if camera.position.y + CAMERA_SHIFT <= position.y:
			camera.position.y += CAMERA_SHIFT
			level.enter_room(roomid_calc())
			
	if facing != v:
		set_facing(v)
	
	slide_to_adjacent_tile(v, $Gfx)

func attack_animation(dir: Vector2):
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_QUINT)
	tw.set_ease(Tween.EASE_IN_OUT)
	var twr = tw.tween_property($Gfx, "position", dir * 4, 0.2)
	twr.from_current()
	tw.chain()
	twr = tw.tween_property($Gfx, "position", Vector2(0, 0), 0.2)
	twr.from_current()

func move_into_node(t, n, dir):
	if n.gametype == "bat":
		attack_animation(dir)
		n.event(Event.make(Event.ATTACK, self))
	elif n.gametype == 'crate':
		# TODO: pushable?
		if n.push(dir):
			move(dir)
		else:
			bump(dir)
	elif n.is_solid():
		var e = Event.make(Event.BUMP, self)
		e['dir'] = dir
		n.event(e)
		bump(dir)
	else:
		move(dir)

func _process(delta):
	pass
	
func say(text):
	var n = preload("res://scenes/Speech.tscn").instantiate()
	n.position = position
	n.init({'text' : text})
	gui_layer.add_child(n)
	n.set_owner(gui_layer)
	
func turn():
	EventBus.emit_signal("player_turn")
	
func unhandled_input_up_down_left_right(t, dir):
	if dir == LEFT or dir == RIGHT:
		face(dir)
	var moved = false
	for n in level.get_nodes_at_tile('obj', t + dir):
		move_into_node(t, n, dir)
		moved = true
		break
	if not moved:
		move(dir)
	get_viewport().set_input_as_handled()
	turn()

func _unhandled_input(event):
	var t = world_to_tile(position)
	if "ui_d" in actions and event.is_action_pressed("ui_d"):
		unhandled_input_up_down_left_right(t, RIGHT)
	elif "ui_a" in actions and event.is_action_pressed("ui_a"):
		unhandled_input_up_down_left_right(t, LEFT)
	elif "ui_s" in actions and event.is_action_pressed("ui_s"):
		unhandled_input_up_down_left_right(t, DOWN)
	elif "ui_w" in actions and event.is_action_pressed("ui_w"):
		unhandled_input_up_down_left_right(t, UP)
	elif "interact" in actions and event.is_action_pressed("interact"):
		for n in level.get_nodes_at_tile('obj', t):
			if n:
				n.event(Event.make(Event.INTERACT, self))
				
		# this is a demo of actions dialog; generalize me
		# I think we will need:
		#   - query adjacent object for interactions
		#   - build a list of actions, qualify with direction (if required)
		#   - build the events and extract the strings?
		#   - 
		for dir in DIRS:
			for n in level.get_nodes_at_tile('obj', t + dir):
				if not n:
					continue
				else:
					if n.gametype == 'bookshelf':
						var scene = preload("res://scenes/ActionsDialog/ActionsDialog.tscn").instantiate()
						scene.init(["hide", "search"])
						get_node("/root/game/CanvasLayer2").add_child(scene)
						get_viewport().set_input_as_handled()
						return
						
		for dir in DIRS:
			for n in level.get_nodes_at_tile('obj', t + dir):
				if not n:
					continue
				else:
					n.event(Event.make(Event.INTERACT, self))
					turn()
		get_viewport().set_input_as_handled()
	elif "get" in actions and event.is_action_pressed("get"):
		say("is that a dagger\nbefore mine eyes ...")
		# TODO: re-enable this.
		#var n = level.event('get', t)
		#if n:
			#self.add_child(n)
			#n.set_owner(self)
			#n.event(Event.make(Event.TAKEN, self))
			#inventory.add(n)
			#turn()
		for dir in DIRS:
			for n in level.get_nodes_at_tile('obj', t + dir):
				if not n:
					continue
				else:
					n.event(Event.make(Event.GET, self))
					turn()
		get_viewport().set_input_as_handled()
	elif "inventory" in actions and event.is_action_pressed("inventory"):
		inventory.toggle()
		get_viewport().set_input_as_handled()
	elif "info" in actions and event.is_action_pressed("info"):
		player_status.toggle()
		get_viewport().set_input_as_handled()
	elif "fire" in actions and event.is_action_pressed("fire"):
		if weapon:
			if weapon.fire():
				turn()
	elif 'quit' in actions and event.is_action_pressed('quit'):
		get_parent().level_change('last', null)
		# TODO: quit (y/n) dialog
	elif 'wait' in actions and event.is_action_pressed('wait'):
		turn()
		
func has_item(item):
	return inventory.has(item)
	
func remove_item(item):
	return inventory.remove(item)
	
func add_item(item):
	return inventory.add(item)
	
func equip(n):
	if n.gametype == "bow-wooden":
		weapon = n
		n.event(Event.make(Event.EQUIPPED, self))
		return true
	elif n.gametype == "arrows":
		if weapon:
			return weapon.equip(n)
	return false
		
func unequip(n):
	if weapon == n:
		weapon = null
		n.event(Event.make(Event.UNEQUIPPED, self))
		return true
	elif n.gametype == "arrows":
		if weapon:
			return weapon.unequip(n)
	return false

func drop(n):
	var t = level.world_to_tile(position)
	remove_child(n)
	var dst = level.find_tile_for_drop(t)
	if dst == null:
		return false
	level.add_node_to_tile('obj', dst, n)
	var e = Event.make(Event.DROPPED, self)
	e['position'] = level.tile_to_world(dst)
	n.event(e)
	return true

func save_all():
	print("Player::save_all")
	var f = FileAccess.open("user://player.save", FileAccess.WRITE)
	for n in [self]:
		if n.filename.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % n.name)
			continue
		if !n.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % n.name)
			continue
		var d = n.save()
		f.store_line(JSON.new().stringify(d))
	f.close()
	print("Player::save_all complete")

func save(d : Dictionary):
	super.save(d)
	d['filename'] = get_scene_file_path()
	d['parent']   = get_parent()
	
