extends Node2D

var stackable = false
var count = 0
var equipped = false

func _ready():
	pass

func init(d: Dictionary):
	equipped_set(d['equipped'])
	$Sprite2D/Count.visible = d['stackable']
	count_set(d['count'])
	$Sprite2D.texture = d['inventory-texture']
	
func equipped_set(val):
	equipped = val
	$Sprite2D/Equipped.visible = equipped	

func count_set(val):
	count = val
	$Sprite2D/Count.text = str(count)
	
func increase():
	if count < 99:
		count_set(count + 1)
		return true
	return false
		
func decrease():
	if count > 0:
		count_set(count - 1)
		
func toggle_equipped():
	equipped_set(not equipped)
