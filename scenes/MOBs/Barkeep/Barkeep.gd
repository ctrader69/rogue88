extends Node2D

@onready var Base = get_node("/root/Base")
@onready var level = get_parent()

var gametype = 'barkeep'
var tile

func is_solid():
	return true
	
func _ready():
	$Upper/AnimationPlayer.play('heave')
	
func init(tile : Vector2):
	self.tile = tile
	position = get_parent().tile_to_world(tile)
	
	var domain = level.floor_domain_get(tile)
	print("barkeep domain")
	for t in domain.keys():
		print("  (%d, %d)" % [t.x, t.y])
		var n = ColorRect.new()
		level.add_child(n)
		n.position = level.tile_to_world(t)
		n.size = Vector2(8, 8)
		n.color = Color(0.0, 1.0, 0.0, 0.5)

func event(e):
	pass
