extends CharacterBody2D

# Speed of the player
const SPEED = 96
const ATTACKING_WALK_SPEED = 96/2

# The HurtBox's Shape for the Player
@onready var hurt_box_shape = $HurtBoxComponent/HurtBoxShape

# Frames, counts the physics frames
var frames : int

# Instantiated Node
@onready var instantiated = $"../Instantiated"

# Components
@onready var health : HealthComponent = $HealthComponent

# Direction variable
var direction : Vector2

# Attacking Bool
var Attacking : bool = false

# Dashing Variables
var DashFrames : int = 7
var DashSpeed : float = 640
var StartedDashFrame : int
var DashCooldownFrames : int = 30
var StartedDashCooldownFrame : int
var DashIsOnCooldown : bool = false
var PlayerIsDashing = false
var PlayerDashDirection : Vector2 = Vector2.ZERO

# Lets the player move or shoot if true
var PlayerCanMove = true
var PlayerCanShoot = true

# Recoil
var RecoilVelocity : Vector2 = Vector2.ZERO
@export var RecoilStrength : float

# Camera
@onready var camera = $"../../Camera2D"

func _physics_process(_delta):
	
	frames += 1
	
	if PlayerIsDashing:
		velocity = PlayerDashDirection * DashSpeed
		if frames >= StartedDashFrame + DashFrames:
			PlayerIsDashing = false
			PlayerCanMove = true
			PlayerCanShoot = true
			hurt_box_shape.disabled = false
			StartedDashCooldownFrame = frames
			DashIsOnCooldown = true
	if DashIsOnCooldown:
		if frames >= StartedDashCooldownFrame + DashCooldownFrames:
			DashIsOnCooldown = false
	
	#region WALKING
	# Set a Vector2 names "direction" to the axis of the player's input
	direction = Vector2(Input.get_axis("Left", "Right"), Input.get_axis("Up", "Down"))
	
	# If two directions are pressed at once, reduce the speed to be consistent with diagonal and 
	
	# This set of code makes the player's movement line up with the
	# Isometic View, by altering the speed of the player's walking
	if abs(direction.x) > 0 and abs(direction.y) > 0:
		direction *= 0.7
		direction.y /= 2
	elif abs(direction.y) > 0:
			direction.y /= 2
	elif abs(direction.x) > 0:
		direction.x /= 1.41
	#endregion
		
	if PlayerCanMove:
		var Speed
		if Input.is_action_pressed("Attack"): Speed = ATTACKING_WALK_SPEED
		else: Speed = SPEED
		velocity = (direction * Speed) + RecoilVelocity
		RecoilVelocity = Vector2.ZERO
	
	move_and_slide()
	

func _process(_delta):
	var MousePos = get_global_mouse_position()

func _input(event):
	
	if event.is_action_pressed("Dash") and (not PlayerIsDashing) and (not DashIsOnCooldown):
		StartedDashFrame = frames
		PlayerIsDashing = true
		PlayerCanMove = false
		PlayerCanShoot = false
		PlayerDashDirection = direction
		hurt_box_shape.disabled = true

func player_to_mouse_angle():
	return (global_position - Vector2(0, 8)).angle_to_point(get_global_mouse_position())

func player_to_mouse_vector():
	return Vector2.from_angle(player_to_mouse_angle())

func PlayerIsHit(damage):
	camera.cause_shake(2)
	print("Player took " + str(damage) + "!")
	health.DealDamage(damage)
