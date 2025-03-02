extends Control

var current = null
var selections = {
	'list' : [],
}

const HIGHLIGHT_COLOR = Color(0.0, 1.0, 0.0, 1.0)
const HIGHLIGHT_SHADOW_COLOR = Color(0.0, 0.5, 0.0, 1.0)

func _ready() -> void:
	selections['list'] = ["LISA", "HAS", "CHIGGERS"]
	for selection in selections['list']:
		add(selection)
	select(selections['list'][0])
	
func select(selection):
	if current == selection:
		return
		
	if current != null:
		var n = selections[current]
		n.set("theme_override_colors/font_color", null)
		n.set("theme_override_colors/font_shadow_color", null)
	
	current = selection
	
	var n = selections[current]
	n.set("theme_override_colors/font_color", HIGHLIGHT_COLOR)
	n.set("theme_override_colors/font_shadow_color", HIGHLIGHT_SHADOW_COLOR)
	
func add(selection):
	var n = Label.new()
	n.text = selection
	n.theme = preload("res://tiny-theme.tres")
	$MarginContainer2/MarginContainer/MarginContainer2/VBoxContainer.add_child(n)
	selections[selection] = n
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_w"):
		# going up the list
		var index = selections['list'].find(current)
		if index == 0:
			return
		index -= 1
		select(selections['list'][index])
	elif event.is_action_pressed("ui_s"):
		# going down the list
		var index = selections['list'].find(current)
		if index == (selections['list'].size() - 1):
			return
		index += 1
		select(selections['list'][index])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
