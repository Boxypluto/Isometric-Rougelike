extends CharacterBody2D

@onready var state_machine : StateMachine = $StateMachine
@onready var guardian_laser : GuardianLaserState = $StateMachine/GuardianLaserState

@onready var player = $"../Player"

@onready var laser = $Squasher/Laser
@onready var laser_collision = $Squasher/Laser/DamagingAreaComponent/CollisionPolygon2D

@onready var ring = $Squasher/Ring

func _ready():
	
	# Setup Guardian Laser State
	guardian_laser.Laser = laser
	guardian_laser.Target = player
	guardian_laser.Collision = laser_collision
	guardian_laser.Parent = ring
	
	# Setup State Machine
	state_machine.initial_state = guardian_laser
	state_machine.setup()

func MountainGuardianHit(damage):
	pass # Replace with function body.
