extends Enemy

# Player
@onready var player : CharacterBody2D = $"../../Player"

# Cast
@onready var cast : RayCast2D = $RayCast2D
var PlayerInSight : bool = false
var LineEndPos : Vector2

# Action Variables
var WaitFrames : int = 60
var WaitedFrames : int = 0

# State Machine
@onready var state_machine : StateMachine = $StateMachine
# States
@onready var blank_state : BlankState = $StateMachine/BlankState
@onready var chase_state : DirectChaseState = $StateMachine/DirectChaseState

func _ready():
	
	# Setup Chase State
	chase_state.Actor = self
	chase_state.Target = player
	
	# Setup State Machine
	state_machine.setup()

func _draw():
	draw_line(global_position, LineEndPos, Color.DODGER_BLUE, 1)

func _process(delta):
	
	cast.target_position = player.position
	if cast.is_colliding():
		LineEndPos = cast.get_collision_point()
		PlayerInSight = true
	else:
		LineEndPos = player.global_position
		PlayerInSight = false
	
	queue_redraw()

func _physics_process(delta):
	
	if PlayerInSight:
		WaitedFrames += 1
	else:
		WaitedFrames = 0
	
	if WaitedFrames >= WaitFrames:
		pass

func OnCubeHit(damage):
	health.DealDamage(damage)

func OnHealthZero():
	death.Kill() 
