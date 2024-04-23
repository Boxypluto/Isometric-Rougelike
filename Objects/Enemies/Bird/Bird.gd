extends Enemy

# State Machine
@onready var state_machine : StateMachine = $StateMachine
# States
@onready var nearby_state : WaitForNearbyState = $StateMachine/WaitForNearbyState
@onready var chase_state : DirectChaseState = $StateMachine/DirectChaseState
@onready var orbit_state : OrbitState = $StateMachine/OrbitState
@onready var dash_state : MoveToPointState = $StateMachine/MoveToPointState

# Player
@onready var player : CharacterBody2D = $"../../Player"
# Dive Timer
@onready var dive_timer = $DiveTimer

# Control Variables
var Speed : float = 64
var ChaseNearDistance : float = 32
var NoticeDistance : float = 64
var OrbitDistance : float = 32
var OrbitSpeed : float = 2
var OrbitSmoothing : float = 0.03

func OnZeroHealth():
	death.Kill()

func OnBirdHit(damage):
	health.DealDamage(damage)

func _ready():
	
	# Chase Setup
	chase_state.Target = player
	chase_state.Actor = self
	chase_state.NearDist = ChaseNearDistance
	chase_state.Speed = Speed
	
	# Near To Setup
	nearby_state.Target = player
	nearby_state.Actor = self
	nearby_state.Distance = NoticeDistance
	
	# Orbit Setup
	orbit_state.Target = player
	orbit_state.Actor = self
	orbit_state.Distance = OrbitDistance
	orbit_state.Speed = OrbitSpeed
	orbit_state.Smoothing = OrbitSmoothing
	
	# Dash Setup
	dash_state.Actor = self
	dash_state.Speed = Speed
	
	# State Machine Setup
	state_machine.initial_state = nearby_state
	state_machine.setup()

func NearToPlayer():
	state_machine.change_state("DirectChaseState")

func ChaseCloseToPlayer():
	state_machine.change_state("OrbitState")
	dive_timer.start()

func StartDive():
	dive_timer.stop()
	dash_state.TargetPos = (position.direction_to(player.position) * OrbitDistance)
	state_machine.change_state("MoveToPointState")

func DashEnded():
	state_machine.change_state("OrbitState")
	dive_timer.start()
