extends Sprite2D
class_name HealthBit
@export var index : int
var player
func _process(delta):
	if player.health.Health >= index: visible = true
	else: visible = false
