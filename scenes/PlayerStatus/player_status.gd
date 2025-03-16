extends Control

var next_index = 0

# TODO: food (stomach)
# TODO: pee (puddle?)
# TODO: cool/mojo (sunglasses?)
# TODO: animate poo (flies)

var data = {
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
	add('poo', 1, 20)

func _process(delta: float) -> void:
	pass
