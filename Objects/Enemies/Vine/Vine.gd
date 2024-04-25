extends Enemy

# Look Direction
var Direction : Vector2

# Animations
@onready var animations = $Animations

# Attacking Variables
var Attacking : bool = false
var AttackCollide : bool = false
var AttackStartDistance = 40

# Damaging Area Component
@onready var damaging_area_component = $DamagingAreaComponent
@onready var blank_state = $StateMachine/BlankState

# State Mahcine
@onready var state_machine = $StateMachine
# States
@onready var wait_state = $StateMachine/WaitForNearbyState

# Damaging Areas
@onready var Collisions : Dictionary = {
	"Base" : $DamagingAreaComponent/BaseCollision,
	"Side" : $DamagingAreaComponent/SideCollision,
	"Back" : $DamagingAreaComponent/BackCollision,
	"Forward" : $DamagingAreaComponent/ForwardCollision,
	"Up" : $DamagingAreaComponent/UpCollision
}

# Animation and Collision Refrence Dictionaries
var IdleAnimations : Dictionary = {
	"Name" : "Idle",
	Vector2(-1, 1) : { "Anim" : "Idle", "Flip" : false, "Coll" : "Base"},
	Vector2(-1, 0) : { "Anim" : "IdleSide", "Flip" : false, "Coll" : "Side"},
	Vector2(-1, -1) : { "Anim" : "IdleBack", "Flip" : false, "Coll" : "Back"},
	Vector2(0, -1) : { "Anim" : "IdleUp", "Flip" : false, "Coll" : "Up"},
	Vector2(1, -1) : { "Anim" : "IdleBack", "Flip" : true, "Coll" : "Back"},
	Vector2(1, 0) : { "Anim" : "IdleSide", "Flip" : true, "Coll" : "Side"},
	Vector2(1, 1) : { "Anim" : "Idle", "Flip" : true, "Coll" : "Base"},
	Vector2(0, 1) : { "Anim" : "IdleForward", "Flip" : false, "Coll" : "Forward"}
}
var SlamAnimations : Dictionary = {
	"Name" : "Slam",
	Vector2(-1, 1) : { "Anim" : "Slam", "Flip" : false, "Coll" : "Base"},
	Vector2(-1, 0) : { "Anim" : "SlamSide", "Flip" : false, "Coll" : "Side"},
	Vector2(-1, -1) : { "Anim" : "SlamBack", "Flip" : false, "Coll" : "Back"},
	Vector2(0, -1) : { "Anim" : "SlamUp", "Flip" : false, "Coll" : "Up"},
	Vector2(1, -1) : { "Anim" : "SlamBack", "Flip" : true, "Coll" : "Back"},
	Vector2(1, 0) : { "Anim" : "SlamSide", "Flip" : true, "Coll" : "Side"},
	Vector2(1, 1) : { "Anim" : "Slam", "Flip" : true, "Coll" : "Base"},
	Vector2(0, 1) : { "Anim" : "SlamForward", "Flip" : false, "Coll" : "Forward"}
}
var UpAnimations : Dictionary = {
	"Name" : "Up",
	Vector2(-1, 1) : { "Anim" : "Up", "Flip" : false, "Coll" : "Base"},
	Vector2(-1, 0) : { "Anim" : "UpSide", "Flip" : false, "Coll" : "Side"},
	Vector2(-1, -1) : { "Anim" : "UpBack", "Flip" : false, "Coll" : "Back"},
	Vector2(0, -1) : { "Anim" : "UpUp", "Flip" : false, "Coll" : "Up"},
	Vector2(1, -1) : { "Anim" : "UpBack", "Flip" : true, "Coll" : "Back"},
	Vector2(1, 0) : { "Anim" : "UpSide", "Flip" : true, "Coll" : "Side"},
	Vector2(1, 1) : { "Anim" : "Up", "Flip" : true, "Coll" : "Base"},
	Vector2(0, 1) : { "Anim" : "UpForward", "Flip" : false, "Coll" : "Forward"}
}

# Currently Used Animation and Collision Dictionary
var CurrentAnimDict = IdleAnimations

# Player
@onready var player : CharacterBody2D = $"../../Player"

func _ready():
	
	# Setup Wait State
	wait_state.Actor = self
	wait_state.Target = player
	wait_state.Distance = AttackStartDistance
	
		# State Machine Setup
	state_machine.initial_state = wait_state
	state_machine.setup()
	
	UnsetAllCollisions()

func _process(delta):
	if not Attacking: SetDirectionToPlayer()

func SetAnimation(Anim : Dictionary = {}, direction : Vector2 = Vector2()):
	
	if Anim.is_empty(): Anim = CurrentAnimDict
	if direction == Vector2(): direction = Direction
	
	#UnsetAllCollisions()
	#if AttackCollide:
		#Collisions[Anim[direction]["Coll"]].disabled = false
		#Collisions[Anim[direction]["Coll"]].visible = true
	
	animations.animation = Anim[direction]["Anim"]
	animations.flip_h  = Anim[direction]["Flip"]
	
	if Anim[direction]["Flip"]: damaging_area_component.scale.x = -1
	else: damaging_area_component.scale.x = 1
	
	animations.play()

func UnsetAllCollisions():
	Collisions["Base"].disabled = true
	Collisions["Side"].disabled = true
	Collisions["Back"].disabled = true
	Collisions["Forward"].disabled = true
	Collisions["Up"].disabled = true
	Collisions["Base"].visible = false
	Collisions["Side"].visible = false
	Collisions["Back"].visible = false
	Collisions["Forward"].visible = false
	Collisions["Up"].visible = false

func SnapVector(vector : Vector2):
	
	var new_vector = vector.normalized()
	
	if new_vector.x > 0.6:
		new_vector.x = 1
	elif new_vector.x < -0.6:
		new_vector.x = -1
	else:
		new_vector.x = 0
	
	if new_vector.y > 0.3:
		new_vector.y = 1
	elif new_vector.y < -0.3:
		new_vector.y = -1
	else:
		new_vector.y = 0
	
	return new_vector

func SetDirectionToPlayer():
	# Get the Normalised Vector of the Direction to the PLayer
	var VectorToPlayer = position.direction_to(player.position)
	var NewDirection = SnapVector(VectorToPlayer)
	# If the direction has changed, change the aniation direction
	if not NewDirection == Direction: SetAnimation({}, NewDirection)
	Direction = NewDirection

func PlayerClose():
	state_machine.change_state("BlankState")
	SetAnimation(SlamAnimations)
	Attacking = true

func AnimationFinished():
	if animations.animation == SlamAnimations[Direction]["Anim"]:
		Collisions[CurrentAnimDict[Direction]["Coll"]].disabled = false
		await get_tree().create_timer(0.3).timeout
		UnsetAllCollisions()
		Attacking = false
		SetAnimation(UpAnimations)
	if animations.animation == UpAnimations[Direction]["Anim"]:
		if position.distance_to(player.position) <= AttackStartDistance:
			SetDirectionToPlayer()
			PlayerClose()
		else:
			SetAnimation(IdleAnimations)
			state_machine.change_state(wait_state.name)

func FrameChanged():
	pass # Replace with function body.

func VineIsHit(damage):
	health.DealDamage(damage)

func OnHealthIsZero():
	death.Kill()
