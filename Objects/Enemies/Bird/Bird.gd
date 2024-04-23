extends Enemy

# State Machine
@onready var state_machine : StateMachine = $StateMachine
# States
@onready var nearby_state : WaitForNearbyState = $StateMachine/WaitForNearbyState
@onready var chase_state : DirectChaseState = $StateMachine/DirectChaseState
@onready var orbit_state : OrbitState = $StateMachine/OrbitState
@onready var dash_state : MoveToPointState = $StateMachine/MoveToPointState

# Sprite Animator
@onready var animation : AnimatedSprite2D = $Animations

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
var OrbitSmoothing : float = 0.5
var DashSpeed : float = 3
var DashDelay : float = 1

func OnZeroHealth():
	death.Kill()

func OnBirdHit(damage):
	health.DealDamage(damage)

func _ready():
	
	# Animation Setup
	animation.speed_scale = 0.5
	
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
	dash_state.Speed = DashSpeed
	dash_state.ActorSprite = animation
	dash_state.SpriteRotationOffset = PI/2
	
	# State Machine Setup
	state_machine.initial_state = nearby_state
	state_machine.setup()

func NearToPlayer():
	animation.speed_scale = 1
	state_machine.change_state("DirectChaseState")

func ChaseCloseToPlayer():
	state_machine.change_state("OrbitState")
	dive_timer.start()

func StartDive():
	animation.animation = "Dive"
	dive_timer.stop()
	orbit_state.Speed = OrbitSpeed/4
	animation.rotation = player.position.angle_to_point(position) + PI/2
	await get_tree().create_timer(DashDelay).timeout
	orbit_state.Speed = OrbitSpeed
	dash_state.TargetPos = ((player.position - position) * 2) + position
	print(dash_state.TargetPos)
	state_machine.change_state("MoveToPointState")

func DashEnded():
	animation.animation = "Fly"
	state_machine.change_state("OrbitState")
	animation.rotation = 0
	dive_timer.start()
