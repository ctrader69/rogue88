extends CharacterBody2D

var gametype = 'arrow'
const SPEED = 256
var v : Vector2

func unit_test():
	init(Vector2(0, 0), Vector2(0.5, 0.5), 0)

func _ready():
	$ReleaseSfx.play()
	#unit_test()
	pass
	
func init(position, dir, angle):
	self.position = position
	v = dir * SPEED
	rotation = angle

func _physics_process(delta):
	var collision = move_and_collide(v * delta)
	if collision:
		stop()
		
func stop():
	v = Vector2(0, 0)
	var t = Timer.new()
	t.wait_time = 1.0
	t.one_shot = true
	t.connect("timeout", Callable(self, "die"))
	add_child(t)
	t.start()
	$AnimationPlayer.play("vanish")
	$CollisionShape2D.set_deferred("disabled", true)
	$HitBox.monitorable = false
		
func die():
	queue_free()
