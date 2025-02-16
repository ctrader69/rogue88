extends GPUParticles2D

# TODO: stain color
# TODO: need to no direction/location of attack

const DATA = {
	'red' : {
		'gradient-texture' : preload("res://gradients/BloodSplatterRed.tres"),
	},
	'purple' : {
		'gradient-texture' : preload("res://gradients/BloodSplatterPurple.tres"),
	}
}

func _ready():
	init("red")

func init(color):
	process_material.color_ramp = DATA[color]['gradient-texture']
	
func hit():
	emitting = true
