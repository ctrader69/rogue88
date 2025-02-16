extends Node2D

var gametype = 'bat'
var hp = 3
var tile = Vector2(0, 0)

func _ready():
	$Sprite2D/AnimationPlayer.play("float")
	
func init(t:Vector2):
	tile = t
	position = t * 8
	
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
		
func event(event):
	if event == 'attack':
		hit()
		hp += -1
		if hp <= 0:
			get_node("..").remove_node_at_tile(tile)
			
func on_flash_timer_expire():
	$Sprite2D/HitFlash.play("RESET")
		
func _on_HitFlash_animation_finished(anim_name):
	print($HitSfx.playing)
	if hp <= 0 and not $HitSfx.playing:
		print("")
		queue_free()

func _on_HitSfx_finished():
	print($Sprite2D/HitFlash.current_animation)
	if hp <= 0 and $Sprite2D/HitFlash.current_animation == "":
		queue_free()
