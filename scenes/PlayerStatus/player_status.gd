extends Control

var next_index = 0

# TODO: pee (puddle?)
# TODO: cool/mojo (sunglasses?)
# TODO: animate poo (flies)

# How to add
#
# 1) create an 'icon' scene.  Use an existing one as a guide.  It should be 8x8.
# 2) create a 'content' png file to use as the filling of the bar.
# 3) connect these in the table below (alphabetical please).
# 4) if your stat should exist at the beginning of a game, add a call to add() in _ready()

var data = {
	'cool' : {
		'icon' : preload("res://scenes/Status/CoolIcon/cool_icon.tscn"),
		'bar-content' : preload("res://assets/images/scenes/StatBar1/content-cool.png"),
	},
	'food' : {
		'icon' : preload("res://scenes/Status/FoodIcon/food_icon.tscn"),
		'bar-content' : preload("res://assets/images/scenes/StatBar1/content-food.png"),
	},
	'health' : {
		'icon' : preload("res://scenes/Status/HealthIcon/health_icon.tscn"),
		'bar-content' : preload("res://assets/images/scenes/StatBar1/content-health.png"),
	},
	'poo' : {
		'icon' : preload("res://scenes/Status/PooIcon/poo_icon.tscn"),
		'bar-content' : preload("res://assets/images/scenes/StatBar1/content-poo.png"),
	}
}

@onready var grid = $MarginContainer/GridContainer

func add(type, numerator, denominator):
	if not type in data:
		assert(false)
	assert(data[type]['index'] == -1)
	
	var icon = data[type]['icon'].instantiate()
	grid.add_child(icon)
	
	var bar = preload("res://scenes/StatBar1/StatBar1.tscn").instantiate()
	bar.fill = data[type]['bar-content']
	
	var ratio = preload("res://scenes/Status/StatRatio/stat_ratio.tscn").instantiate()
	
	data[type]['bar'] = bar
	data[type]['ratio'] = ratio
	data[type]['index'] = next_index
	next_index += 1
	
	update(type, numerator, denominator)
	
	grid.add_child(bar)
	grid.add_child(ratio)
	
func update(type, numerator, denominator):
	var bar = data[type]['bar']
	bar.percent = int((numerator * 100) / denominator)
	
	var ratio = data[type]['ratio']
	ratio.numerator = numerator
	ratio.denominator = denominator

func toggle():
	if visible:
		visible = false
	else:
		for key in data:
			if data[key]['bar']:
				data[key]['bar'].animate()
			if data[key]['ratio']:
				data[key]['ratio'].animate()				
		visible = true

func _ready() -> void:
	for key in data:
		data[key]['index'] = -1
		data[key]['bar'] = null
		data[key]['ratio'] = null
	add('health', 20, 20)
	add('cool', 10, 10)
	add('food', 0, 20)
	add('poo', 1, 20)

func _process(delta: float) -> void:
	pass
