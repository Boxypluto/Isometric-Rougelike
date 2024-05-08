extends Node2D
class_name Spawner
@onready var state_machine = $"../StateMachine"
@onready var state = $"../StateMachine/SpawnBirdsState"
func _process(delta):
	if state_machine.state_name == state.name:
		visible = true
	else:
		visible = false
