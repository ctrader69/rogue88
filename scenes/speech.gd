extends Control

# TODO: automate wrapping
# TODO: support color
# TODO: support multiple sentences (no fade in between)
# TODO: perhaps speech duration should be text length dependent
# TODO: make playout an option
# TODO: playout (variable length), playout (fixed length, spaces)
# TODO: colors

const WRITE_DURATION_PER_CHAR = 0.025
const FADE_DURATION = 2.0
@export var text = 'default-text'
var state = 'writing'

func init(d):
	if 'text' in d:
		text = d['text']
		
func state_set(new_state):
	match new_state:
		'writing' :
			# TODO: experiment with replacing hidden text with spaces so the label doesn't resize as it's writing.
			$Label.text = ""
			var tw = get_tree().create_tween()
			tw.tween_method(update_text, 0, text.length(), WRITE_DURATION_PER_CHAR * text.length())
			tw.tween_callback(self.state_set.bind("fading"))
		'fading' :
			var tw = get_tree().create_tween()
			tw.tween_property(self, "position", position + Vector2(0, -8), FADE_DURATION)
			tw.parallel()
			tw.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), FADE_DURATION)
			tw.tween_callback(self.state_set.bind("die"))
		'die' :
			queue_free()
	state = new_state
	
func _ready():
	state_set('writing')
		
func update_text(i):
	$Label.text = text.substr(0, int(i))
