extends Enemy

# Player
@onready var player : CharacterBody2D = $"../../Player"

# AfterImage Scene
const CUBE_AFTER_IMAGE = preload("res://Objects/Enemies/Cube/CubeAfterImage.tscn")

# Animations
@onready var animations = $Animations

# Pointer Animations
@onready var pointer : AnimatedSprite2D = $CubePointer

# Target Texture
const CUBE_TARGET = preload("res://Objects/Enemies/Cube/CubeTargetAnimation.tres")

# Cast
@onready var cast : RayCast2D = $RayCast2D
var PlayerInSight : bool = false
var LineEndPos : Vector2

# Action Variables
var WaitFrames : int = 180
var WaitedFrames : int = 0
var LineColor = Color.DODGER_BLUE
var WaitTime : float = 1
var Dashing : bool = false

# State Machine
@onready var state_machine : StateMachine = $StateMachine
# States
@onready var blank_state : BlankState = $StateMachine/BlankState
@onready var move_state : MoveToPointState = $StateMachine/MoveToPointState

var Target = AnimatedSprite2D.new()

var frame : int = 0
var Idle : bool = true

var FlashMat
var Started = false

func _ready():
	
	# Setup Target
	Target.sprite_frames = CUBE_TARGET
	player.add_child(Target)
	#Target.y_sort_enabled = true
	Target.play("Blank")
	
	# Setup Chase State
	move_state.Actor = self
	move_state.Speed = 16
	
	# Setup State Machine
	state_machine.initial_state = blank_state
	state_machine.setup()
	
	super()
	
	FlashMat = material
	material = null
	
	Started = true

#func _draw():
	#draw_line(Vector2.ZERO, LineEndPos - position, LineColor, 1)

func _process(delta):
	
	if Started:
		frame += 1
		
		cast.target_position = player.global_position - cast.global_position
		if cast.is_colliding():
			LineEndPos = cast.get_collision_point()
			PlayerInSight = false
			LineColor = Color.DODGER_BLUE
		else:
			LineEndPos = player.global_position
			PlayerInSight = true
			LineColor = Color.CRIMSON
		
		queue_redraw()

func _physics_process(delta):
	
	if Started:
		if Idle:
			if PlayerInSight:
				WaitedFrames += 1
				Target.play("Target")
				if pointer.animation != "Grow": pointer.animation = "Grow"
				pointer.frame = floorf((WaitedFrames/float(WaitFrames))*4)-1
				print(pointer.frame)
			else:
				WaitedFrames = 0
				Target.play("Blank")
				if pointer.animation != "Shrink": pointer.play("Shrink")
			
			if WaitedFrames > WaitFrames:
				Idle = false
				move_state.TargetPos = player.position
				animations.speed_scale = 0.5
				animations.modulate = Color.from_hsv(0.8, clamp(WaitedFrames/float(WaitFrames), 0, 1)*0.6, (clamp(WaitedFrames/float(WaitFrames), 0, 1)*2) + 1)
				await get_tree().create_timer(WaitTime).timeout
				animations.speed_scale = 2
				WaitedFrames = 0
				state_machine.change_state(move_state.name)
				Dashing = true
			else:
				animations.speed_scale = 1 + (float(WaitedFrames)/WaitFrames/2.0)
				animations.modulate = Color.from_hsv(0, clamp(WaitedFrames/float(WaitFrames), 0, 1)*0.6, (clamp(WaitedFrames/float(WaitFrames), 0, 1)*2) + 1)
		
		else:
			if pointer.animation != "Shrink": pointer.play("Shrink")
		
		pointer.modulate = animations.modulate
		pointer.rotation = pointer.global_position.angle_to_point(player.global_position)
		
		if frame % 2 == 0:
			AfterImage()

func OnCubeHit(damage):
	health.DealDamage(damage)
	material = FlashMat
	await FlashEnded
	material = null

func OnHealthZero():
	Target.queue_free()
	death.Kill() 

func FinishedDash():
	animations.speed_scale = 1
	Dashing = false
	state_machine.change_state(blank_state.name)
	await get_tree().create_timer(WaitTime).timeout
	Idle = true

func AfterImage():
	if Dashing:
		var image = CUBE_AFTER_IMAGE.instantiate()
		get_tree().root.add_child(image)
		image.setup(animations.frame)
		image.position = position
		image.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
