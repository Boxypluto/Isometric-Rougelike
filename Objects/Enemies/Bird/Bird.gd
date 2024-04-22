extends Enemy

@onready var state_machine = $StateMachine
@onready var nearby_state = $StateMachine/WaitForNearbyState
@onready var chase_state = $StateMachine/DirectChaseState
@onready var player = $"../../Player"

@export var Speed : float
@export var ChaseNearDistance : float
@export var NoticeDistance : float

func OnZeroHealth():
	pass # Replace with function body.

func OnBirdHit(damage):
	pass # Replace with function body.

func _process(delta):
	pass

func _ready():
	
	# Chase Setup
	print(player)
	chase_state.Target = player
	print(str(chase_state.Target) + " = Target")
	chase_state.Actor = self
	chase_state.NearDist = ChaseNearDistance
	chase_state.Speed = Speed
	
	# Near To Setup
	nearby_state.Target = player
	nearby_state.Actor = self
	nearby_state.Distance = NoticeDistance
	
	# State Machine Setup
	state_machine.initial_state = nearby_state
	state_machine.setup()

func NearToPlayer():
	state_machine.change_state("DirectChaseState")

func ChaseCloseToPlayer():
	print("BIRD IS CLOSE TO PLAYER AND IN CHASE STATE!")
