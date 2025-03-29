extends "res://scenes/Lifeform.gd"

func init(d):
	position = d['position']
	gametype = "npc"
	speech_color = Color("#007bff")
	
func _ready():
	var t = Timer.new()
	add_child(t)
	t.wait_time = 5
	t.one_shot = false
	t.connect("timeout", Callable(self, "on_timer_expire"))
	t.start()
	
func on_timer_expire():
	say(Gibberish.sentence_fragment())
