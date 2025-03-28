extends Node2D

var gametype = "bow-wooden"
var ammo = null
var infinite = true

func _ready():
	pass
	
func _process(delta):
	pass
	
func init(initdata: Dictionary):
	var d = {
		'position' : Vector2i(0, 0),
	}
	d.merge(initdata, true)
	self.position = d['position']
	
func set_facing(v):
	if v.x < 0:
		self.scale.x = -1
	if v.x > 0:
		self.scale.x = 1
	
func fire():
	if not ammo and not infinite:
		return false
	# TODO: arrow count
	# TODO: weapon attachment point
	var arrow_spawn = get_parent().position
	var arrow_target = get_global_mouse_position()
	var arrow_direction = (arrow_target - arrow_spawn).normalized()
	var arrow_angle = arrow_direction.angle()
	var n = preload("res://scenes/Arrow/Arrow.tscn").instantiate()
	n.init(arrow_spawn, arrow_direction, arrow_angle)
	var parent = get_node("/root/game")
	parent.add_child(n)
	n.set_owner(parent)
	return true
	
# TODO: need to add this to the scene tree.

func equip(n):
	ammo = n
	return true
	
func unequip(n):
	if ammo == n:
		ammo = null
		return true
	return false
	
func is_solid():
	return false
	
func event(e):
	if e['type'] == Events.DROPPED:
		visible = true
		$Gfx/Sprite.frame = 0
		position = e['position']
	elif e['type'] == Events.TAKEN:
		visible = false
		position = Vector2i(0, 0)
	elif e['type'] == Events.EQUIPPED:
		e['src'].add_child(self)
		set_owner(e['src'])
		visible = true
		$Gfx/Sprite.frame = 1
		# TODO: how to signal that the ammo gets unequipped too
	elif e['type'] == Events.UNEQUIPPED:
		visible = false
		$Gfx/Sprite.frame = 1
