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
	orbit_state.SpriteRotationOffset = PI/2
	
	# Dash Setup
	dash_state.Actor = self
	dash_state.Speed = DashSpeed
	dash_state.ActorSprite = animation
	dash_state.SpriteRotationOffset = PI/2
	
	# State Machine Setup
	state_machine.initial_state = nearby_state
	state_machine.setup()
	
	super()

func NearToPlayer():
	
	# Set Animation Speed to Normal
	animation.speed_scale = 1
	# Change to Chase State
	state_machine.change_state("DirectChaseState")

func ChaseCloseToPlayer():
	
	# Change to Orbit State
	state_machine.change_state("OrbitState")
	# Start Dive Timer
	dive_timer.start()

func StartDive():
	
	# Start Dive Animation
	animation.animation = "Dive"
	# Stop Dive Timer
	dive_timer.stop()
	# Slow Speed
	orbit_state.Speed = OrbitSpeed/4
	# Steepen Smoothing
	orbit_state.Smoothing = 0.001
	# Rotate Sprite to Player
	orbit_state.ActorSprite = animation
	
	# Wait for DashDelay Seconds
	await get_tree().create_timer(DashDelay).timeout
	
	# Stop Looking Towards Player
	orbit_state.ActorSprite = null
	# Reset Speed
	orbit_state.Speed = OrbitSpeed
	# Reset Smoothing
	orbit_state.Smoothing = OrbitSmoothing
	# Setup Dash to Overshoot Player by Twice the Distance from the Player
	dash_state.TargetPos = ((player.position - position) * 2) + position
	# Change to Dash State
	state_machine.change_state("MoveToPointState")

func DashEnded():
	
	# Set Aniamtion to Fly
	animation.animation = "Fly"
	
	# If the Bird is Still Close to the Player...
	if position.distance_to(player.position) <= ChaseNearDistance:
		# Change to Orbit State
		state_machine.change_state("OrbitState")
	else:
		# Otherwise Chase
		state_machine.change_state(chase_state.name)
	
	# Reset Rotation
	animation.rotation = 0
	# Start the Dive Timer
	dive_timer.start()
