extends Control

var next_index = 0

# TODO: food (stomach)
# TODO: pee (puddle?)
# TODO: cool/mojo (sunglasses?)
# TODO: get bar animation working again
# TODO: animate ratio
# TODO: update bar and ratio
# TODO: scrollbar or arrows
# TODO: search (if we get too many)

var data = {
	'health' : {
		'icon' : preload("res://scenes/Status/HealthIcon/health_icon.tscn"),
		'bar-content' : preload("res://assets/images/scenes/StatBar1/content-health.png"),
		'index' : -1
	},
	'poo' : {
		'icon' : preload("res://scenes/Status/PooIcon/poo_icon.tscn"),
		'bar-content' : preload("res://assets/images/scenes/StatBar1/content-poo.png"),
		'index' : -1
	}
}

@onready var grid = $MarginContainer/GridContainer

func add(type):
	if not type in data:
		assert(false)
	assert(data[type]['index'] == -1)
	
	var icon = data[type]['icon'].instantiate()
	grid.add_child(icon)
	
	var bar = preload("res://scenes/StatBar1/StatBar1.tscn").instantiate()
	bar.fill = data[type]['bar-content']
	grid.add_child(bar)
	
	var ratio = preload("res://scenes/Status/StatRatio/stat_ratio.tscn").instantiate()
	#ratio.top = 15
	#ratio.bottom = 100
	grid.add_child(ratio)
	
	data[type]['index'] = next_index
	next_index += 1

func _ready() -> void:
	add('health')
	add('poo')

func _process(delta: float) -> void:
	pass
