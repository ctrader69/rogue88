extends "res://scenes/Lifeform.gd"

var speech_color = Color("#007bff")

@onready var gui_layer = get_node("./CanvasLayer")

func say(text):
	var n = preload("res://scenes/Speech.tscn").instantiate()
	n.position = position + Vector2($MouthPosition.position.x, -2)
	n.init({'text' : text, 'color' : speech_color})
	gui_layer.add_child(n)
	n.set_owner(gui_layer)

func init(d):
	position = d['position']
	gametype = "npc"
	
func _ready():
	var t = Timer.new()
	add_child(t)
	t.wait_time = 5
	t.one_shot = false
	t.connect("timeout", Callable(self, "on_timer_expire"))
	t.start()
	
func on_timer_expire():
	say(Gibberish.sentence_fragment())
	
	
