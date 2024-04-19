extends CharacterBody2D

# Speed of the player
const SPEED = 96

# The HurtBox's Shape for the Player
@onready var hurt_box_shape = $HurtBoxComponent/HurtBoxShape

# The Spell Scene
const PLAYER_SPELL = preload("res://Player/PlayerSpell.tscn")

# Frames, counts the physics frames
var frames : int

# Instantiated Node
@onready var instantiated = $"../Instantiated"

# The player's attack node and sprite
@onready var attack : AnimatedSprite2D = $Attack

# The Area2D of the player's attack
@onready var attack_area : Area2D = $Attack/AttackArea
# The CollisionShape of the player's attack
@onready var attack_shape : CollisionShape2D = $Attack/AttackArea/AttackShape

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

func _physics_process(delta):
	
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
		velocity = (direction * SPEED) + RecoilVelocity
		RecoilVelocity = Vector2.ZERO
	
	move_and_slide()
	
	if Input.is_action_pressed("Attack") and frames % 10 == 0 and PlayerCanShoot:
		var spell : Node = PLAYER_SPELL.instantiate()
		add_child(spell)
		spell.rotation = attack.global_position.angle_to_point(get_global_mouse_position())
		spell.global_position = attack.global_position
		spell.StartVelocity = Vector2.ZERO
		#SuccessfullMelleAttack(spell.rotation)

func _process(delta):
	
	var MousePos = get_global_mouse_position()
	
	var attackAngle = attack.global_position.angle_to_point(MousePos)
	
	#region SCRAPPED ATTACK
	
	if not attack.animation == "Attack" and false:
		attack.rotation = attackAngle
	
	if attack.animation == "Attack" and attack.frame == 3 and false:
		attack.animation = "Nothing"
		Attacking = false
		attack_shape.disabled = true
	
#endregion
	

func _input(event):
	
	if event.is_action_pressed("Dash") and (not PlayerIsDashing) and (not DashIsOnCooldown):
		StartedDashFrame = frames
		PlayerIsDashing = true
		PlayerCanMove = false
		PlayerCanShoot = false
		PlayerDashDirection = direction
		hurt_box_shape.disabled = true
		
	
	##region SCRAPPED_ATTACK
	#
	#if event.is_action_pressed("Attack") and false:
		#attack.animation = "Attack"
		#Attacking = true
		#attack_shape.disabled = false
##endregion
	#
	#if event.is_action("Attack"):
		#var spell : Node = PLAYER_SPELL.instantiate()
		#instantiated.add_child(spell)
		#spell.rotation = attack.global_position.angle_to_point(get_global_mouse_position())
		#spell.global_position = attack.global_position
		#SuccessfullMelleAttack(spell.rotation)

func SuccessfullMelleAttack(angle = attack.rotation):
	RecoilVelocity = Vector2.from_angle(angle + PI) * RecoilStrength

func player_to_mouse_angle():
	return (global_position - Vector2(0, 8)).angle_to_point(get_global_mouse_position())

func player_to_mouse_vector():
	return Vector2.from_angle(player_to_mouse_angle())


func PlayerIsHit(damage):
	print("Player took " + str(damage) + "!")
	health.DealDamage(damage)
