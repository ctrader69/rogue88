extends Node2D

@onready var Event = get_node("/root/Events")
@onready var EventBus = get_node("/root/EventBus")
@onready var mobs = get_node("/root/Mobs")

var hp = 3
var alive = true
var facing = Vector2i(1, 0)
var gametype = 'lifeform'
# GODOT_4 - same name as fn
var hit_animation_playing_var = false
var hit_sfx_playing = false
var effects = []
var nBloodSplatter = null
var mouth_marker = null
var speech_color = Color("#ffffff")

func slide_to_adjacent_tile(dir: Vector2, n: Control):
	# important: called after position has been updated so need to tween from previous position to
	# current.
	# TODO: TILESIZE
	var dest = n.position
	n.position -= dir * 8
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_CUBIC)
	tw.set_ease(Tween.EASE_IN_OUT)
	var twr = tw.tween_property(n, "position", dest, 0.1)
	
func die():
	var level = get_parent()
	var bloodstain = preload("res://scenes/BloodStain/BloodStain.tscn").instantiate()
	level.add_child(bloodstain)
	bloodstain.init({
		'position' : position,
		'level' : 'heavy',
		'color' : mobs.MOBS[gametype]['blood-color'],
	})
	var tile = level.world_to_tile(position)
	level.add_node_to_tile('obj', tile, bloodstain)
	queue_free()
	
func hit_animation():
	hit_animation_complete()
	
func hit_animation_playing():
	return false
	
func hit_animation_complete():
	hit_animation_playing_var = false
	if not alive and not hit_sfx_playing:
		die()
	
func hit_sfx():
	hit_sfx_complete()
	
func hit_sfx_complete():
	hit_sfx_playing = false
	if not alive and not hit_animation_playing_var:
		die()
	
func hit():
	var damage = -1
	add_child(preload("res://scenes/HeadLabel/HeadLabel.tscn").instantiate().init(str(damage), Vector2(0, -4), Color('#ff004d'), Color('#7e2553')))
	hp += damage
	if hp 	<= 0:
		alive = false
		# TODO: remove this, lifeform remains as a corpse.
		# var level = get_parent()
		# var tile = level.world_to_tile(position)
		# level.remove_node_from_tile('obj', tile, self)
	hit_animation_playing_var = true
	hit_sfx_playing = true
	hit_animation()
	hit_sfx()
	if nBloodSplatter:
		nBloodSplatter.hit()
	
func is_solid():
	return true
	
func load(d):
	facing.x = d['facing.x']
	facing.y = d['facing.y']
	hp = d['hp']
	position.x = d['position.x']
	position.y = d['position.y']
	
func event(e):
	match e['type']:
		Event.ATTACK:
			if alive:
				hit()
		
func hitbox_area_entered(area):
	var n = area
	while true:
		n = n.get_parent()
		if "gametype" in n:
			if n.gametype == 'arrow':
				n.stop()
				event(Event.make(Event.ATTACK, self))
				# TODO: arrow type
				# if len(effects) == 0:
				#	var effect = preload("res://scenes/FireEffect/FireEffect.tscn").instance()
				#	effect.set_owner(self)
				#	add_child(effect)
				#	effect.position = Vector2(4.5, 8)
				#	effects.append(effect)
			break
			
func on_turn():
	# return -> continue?
	if not alive:
		return false
	return true

func _ready():
	EventBus.connect("player_turn", Callable(self, "on_turn"))
	var nBloodSplatterPosition = find_child("BloodSplatterPosition")
	if nBloodSplatterPosition:
		nBloodSplatter = preload("res://scenes/BloodSplatter/BloodSplatter.tscn").instantiate()
		nBloodSplatterPosition.add_child(nBloodSplatter)

func save(d : Dictionary):
	d['facing.x']   = facing.x
	d['facing.y']   = facing.y
	d['hp']         = hp
	d['position.x'] = position.x
	d['position.y'] = position.y
	
func set_gametype(gametype):
	self.gametype = gametype
	if nBloodSplatter:
		nBloodSplatter.init(mobs.MOBS[gametype]['blood'])
		
func say(text):
	var n = preload("res://scenes/Speech.tscn").instantiate()
	if mouth_marker:
		n.position = position + Vector2(mouth_marker.position.x, -2)
	else:
		n.position = position
	n.init({'text' : text, 'color' : speech_color})
	var text_layer = get_node("/root/game/TextLayer")
	text_layer.add_child(n)
	n.set_owner(text_layer)
