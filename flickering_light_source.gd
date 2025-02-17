extends Node2D

func _ready() -> void:
	disable()
	$PointLight2D.enabled = false
	$PointLight2D2.enabled = false
	
func _enable_disable(val: bool):
	$PointLight2D.enabled = val
	$PointLight2D2.enabled = val

func enable():
	_enable_disable(true)
	$PointLight2D/AnimationPlayer.play("energy")
	
	
func disable():
	_enable_disable(false)
	#$PointLight2D.AnimationPlayer.stop("energy")

func _process(delta: float) -> void:
	pass
