extends Node2D

# TODO: change image to grayscale and make the color dynamic

var gametype = 'blood'

func unit_test():
	init({
		'position' : Vector2(0,0),
		'level' : 'heavy',
		'color' : Color(255,0,0),
	})

func _ready():
	# unit_test()
	pass
	
func is_solid():
	return false
	
func init(d : Dictionary):
	self.position = d['position']
	match d['level']:
		'heavy':
			$Sprite2D.frame = int(randf_range(10, 14))
		'medium':
			$Sprite2D.frame = int(randf_range(5, 9))
		'light':
			$Sprite2D.frame = int(randf_range(0, 4))
	self.modulate = d['color']
			
func save(d : Dictionary):
	d['filename']     = get_scene_file_path()
	d['Sprite2D.frame'] = $Sprite2D.frame
	d['parent']       = get_parent().get_path()
	d['position.x']   = position.x
	d['position.y']   = position.y

func load(d):
	position.x = d['position.x']
	position.y = d['position.y']
	$Sprite2D.frame = d['Sprite2D.frame']
	
func event(e):
	pass
