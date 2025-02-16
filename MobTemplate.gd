extends "res://scenes/Lifeform.gd"

func init(t:Vector2):
	position = t * 8
	
func _ready():
	super._ready()
	set_gametype('FILL-ME-IN')
	# FILL-ME-IN
	
func on_turn():
	if not super.on_turn():
		return
	
func hit_animation():
	pass
	
func hit_sfx():
	pass
	
func save(d : Dictionary):
	super.save(d)
	d['filename'] = get_scene_file_path()
	d['parent'] = get_parent()
	
func load(d : Dictionary):
	super.load(d)
	
func event(e):
	# match e['type']:
	#     Event.EVENT:
	#         pass
	pass

# hitbox(es) for interaction with projectiles:
#
# 1. create one or more instances of the sub-tree below.  You may want multiple
#    instances if the shape of your sprite frames varies greatly.  If you use
#    multiple, you'll need to enable/disable monitoring/monitorable as you
#    changes frames:
#    	Area2D
#    		CollisionShape2D
#
# 2. connect the 'area_entered' signal.  Call the parent hitbox_area_entered() method.
# func _on_Area2D_area_entered(area):
#	hitbox_area_entered(area)

# blood splatter - if you want blood splatter ...
#
# 1. Add a Position2D child node and rename it 'BloodSplatterPosition'.
#
# That's it.  No code needed.
