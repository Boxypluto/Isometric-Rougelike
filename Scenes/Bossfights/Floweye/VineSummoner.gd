extends Node2D
class_name VineSummoner
var vine : Node2D
@onready var sprite_2d = $Sprite2D
@onready var state_machine = $"../StateMachine"
@onready var vine_summon : AudioStreamPlayer2D = $"Vine Summon"
var HasPlayed : bool = false
func _process(delta):
	if state_machine.state_name == "SummonVinesState":
		if not HasPlayed and vine_summon:
			HasPlayed = true
		sprite_2d.visible = true
	else:
		HasPlayed = false
		sprite_2d.visible = false
