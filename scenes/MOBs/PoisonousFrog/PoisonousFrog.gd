extends "res://scenes/Lifeform.gd"

# TODO: face direction of travel
# TODO: face player

var blinkTimer = null

func init(d: Dictionary):
	position = d['position']
	
func schedule_blink():
	blinkTimer.wait_time = randf_range(0.5, 2.0)
	blinkTimer.start()
	
func blink():
	$Gfx/AnimationPlayer.play('blink')
	schedule_blink()

func _ready():
	super._ready()
	set_gametype('poisonous-frog')
	blinkTimer = Timer.new()
	blinkTimer.one_shot = true
	blinkTimer.connect('timeout', Callable(self, 'blink'))
	add_child(blinkTimer)
	schedule_blink()
	
func on_turn():
	if not super.on_turn():
		return
		
func save(d : Dictionary):
	super.save(d)
	d['filename'] = get_scene_file_path()
	d['parent'] = get_parent()
	
func load(d : Dictionary):
	super.load(d)

func _on_Area2D_area_entered(area):
	hitbox_area_entered(area)
