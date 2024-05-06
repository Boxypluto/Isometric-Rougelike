extends Node2D
class_name VineSummoner
var vine : Node2D
@onready var sprite_2d = $Sprite2D
@onready var state_machine = $"../StateMachine"
func _process(delta):
	if state_machine.state_name == "SummonVinesState":
		sprite_2d.visible = true
	else:
		sprite_2d.visible = false
