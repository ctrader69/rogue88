extends "res://scenes/Lifeform.gd"

func _ready():
	super._ready()
	set_gametype('rat')
	set_frame(1)
	
func init(d: Dictionary):
	position = d['position']
	
func set_frame(f):
	$Sprite2D.frame = f
	if f == 0:
		$Eye.position = Vector2(3, 5)
	else:
		$Eye.position = Vector2(2, 6)
		
func save(d : Dictionary):
	super.save(d)
	d['filename'] = get_scene_file_path()
	d['parent'] = get_parent()
	
func load(d : Dictionary):
	super.load(d)
	
func on_turn():
	if not super.on_turn():
		return
		
func _on_Area2D_area_entered(area):
	hitbox_area_entered(area)
