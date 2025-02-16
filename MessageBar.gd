extends Node2D

# TODO: alignment still feels wrong
# TODO: move font to its own script, how to re-use?  Make a resource?

const SCREEN_WIDTH = 128
const BAR_SPEED = 0.5
const BAR_HEIGHT = 7
const TEXT_SPEED = 1
const TEXT_WAIT = 1
const TEXT_STRIDE = 3.5

var msg
var y
var bgcolor
var fgcolor
var theme

func _ready():
	var font = FontFile.new()
	font.add_texture(preload("res://assets/font.png"))
	font.height = 6
	var offset = 0
	for c in range(32, 122):
		font.add_char(c, 0, Rect2(offset, 0, 3, 5), Vector2(0, 0), TEXT_STRIDE)
		offset += 4
	$Label.set('theme_override_fonts/font', font)
	# uncommet
	#play('Snakes!', 64.0, Color('#ac3232'), Color('#45283c'))
	
func play(msg, y, bgcolor, fgcolor):
	self.msg = msg
	self.y = y
	self.bgcolor = bgcolor
	self.fgcolor = fgcolor
	$Label.text = msg
	$Label.position = Vector2(SCREEN_WIDTH, y + 1)
	$Bar.color = bgcolor
	$Label.set('theme_override_colors/font_color', self.fgcolor)
	bar_in()

func bar_in():
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_CUBIC)
	tw.set_ease(Tween.EASE_IN)
	tw.set_parallel(true)
	$Bar.size = Vector2(128, 0.0)
	$Bar.position = Vector2(0.0, self.y + TEXT_STRIDE)
	tw.tween_property($Bar, "size", Vector2(128, BAR_HEIGHT), BAR_SPEED)
	tw.tween_property($Bar, "position", Vector2(0.0, self.y), BAR_SPEED)
	tw.connect('finished', Callable(self, 'msg_in'))
	
func msg_in():
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_CUBIC)
	tw.set_ease(Tween.EASE_OUT)
	var x = (128 - (len(self.msg) * 3.5)) / 2
	tw.tween_property($Label, "position", Vector2(x, self.y + 1), TEXT_SPEED)
	tw.connect('finished', Callable(self, 'msg_wait'))
	
func msg_wait():
	var t = Timer.new()
	t.one_shot = true
	t.wait_time = TEXT_WAIT
	t.connect("timeout", Callable(self, 'msg_out').bind(t))
	add_child(t)
	t.start()
	
func msg_out(t):
	t.queue_free()
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_CUBIC)
	tw.set_ease(Tween.EASE_IN)
	var x = 0 - (128 - (len(self.msg) * 3.5)) / 2
	tw.tween_property($Label, "position", Vector2(x, self.y + 1), TEXT_SPEED)
	tw.connect('finished', Callable(self, 'bar_out'))
	
func bar_out():
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_CUBIC)
	tw.set_ease(Tween.EASE_IN)
	tw.set_parallel(true)
	tw.tween_property($Bar, "size", Vector2(128, 0.0), BAR_SPEED)
	tw.tween_property($Bar, "position", Vector2(0.0, self.y + TEXT_STRIDE), BAR_SPEED)
