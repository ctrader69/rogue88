extends "res://scenes/Lifeform.gd"

# TODO: face direction of travel
# TODO: face player

func init(d: Dictionary):
	position = d['position']

func _ready():
	super._ready()
	gametype = 'zombie'
	$Gfx/TorsoAnimation.play("heave")
	$Gfx/TorsoAnimation.seek(randf_range(0.0, 1.0))

func on_turn():
	if alive:
		$AI.on_turn()

func save(d : Dictionary):
	super.save(d)
	d['filename'] = get_scene_file_path()
	d['parent'] = get_parent()

func load(d : Dictionary):
	super.load(d)

func _on_HitBox_area_entered(area):
	hitbox_area_entered(area)
	
func hit_animation():
	$Gfx/HitFlash.play("hitflash")
	var t = Timer.new()
	add_child(t)
	t.wait_time = 0.25
	t.one_shot = true
	t.connect("timeout", Callable(self, "on_hit_flash_expire"))
	t.start()
	
func hit_sfx():
	$HitSfx.play()

func _on_HitSfx_finished():
	hit_sfx_complete()

func on_hit_flash_expire():
	$Gfx/HitFlash.play("RESET")
	hit_animation_complete()
	
func move(dir):
	var level = get_parent()
	var t = Vector2i(position / 8)
	level.remove_node_from_tile('obj', t, self)
	t += dir
	level.add_node_to_tile('obj', t, self)
	position = t * 8
	slide_to_adjacent_tile(dir, $Gfx)
