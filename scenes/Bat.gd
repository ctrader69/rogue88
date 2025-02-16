extends Node2D

@onready var Event = get_node("/root/Events")

var gametype = 'bat'
var hp = 3
var alive = true

func _ready():
	$Sprite2D/AnimationPlayer.play("float")
	
func init(d: Dictionary):
	position = d['position']
	
func is_solid():
	return true
	
func hit_flash():
	$Sprite2D/HitFlash.play("flash")
	var t = Timer.new()
	add_child(t)
	t.wait_time = 0.25
	t.one_shot = true
	t.connect("timeout", Callable(self, "on_flash_timer_expire"))
	t.start()
	
func hit():
	hit_flash()
	$HitSfx.play()
	
func event(e):
	match e['type']:
		Event.ATTACK:
			if alive:
				hit()
				hp += -1
				add_child(preload("res://scenes/HeadLabel/HeadLabel.tscn").instantiate().init(str(-1), Vector2(0, -4), Color('#ff004d'), Color('#7e2553')))
				if hp <= 0:
					alive = false
					var level = get_parent()
					var tile = level.world_to_tile(position)
					level.remove_node_from_tile('obj', tile, self)
			
func on_flash_timer_expire():
	$Sprite2D/HitFlash.play("RESET")
	
func die():
#	var bloodstain = preload("res://scenes/BloodStain/BloodStain.tscn").instance()
#	bloodstain.init(position, 'light')
#	var level = get_parent()
#	var tile = level.world_to_tile(position)
#	level.set_node_at_tile('obj', tile, bloodstain)
	queue_free()
		
func _on_HitFlash_animation_finished(anim_name):
	if hp <= 0 and not $HitSfx.playing:
		queue_free()

func _on_HitSfx_finished():
	if hp <= 0 and $Sprite2D/HitFlash.current_animation == "":
		die()

func _on_HitBox_area_entered(area):
	var n = area.get_parent()
	if n.gametype == 'arrow':
		n.stop()
		event(Event.make(Event.ATTACK, n))

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
