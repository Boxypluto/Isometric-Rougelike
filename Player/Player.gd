extends CharacterBody2D

# Speed of the player
const SPEED = 64

# The player's attack node and sprite
@onready var attack : AnimatedSprite2D = $Attack

# The Area2D of the player's attack
@onready var attack_area : Area2D = $Attack/AttackArea

# Attacking Bool
var Attacking : bool = false

func _physics_process(delta):

	#region WALKING
	# Set a Vector2 names "direction" to the axis of the player's input
	var direction : Vector2 = Vector2(Input.get_axis("Left", "Right"), Input.get_axis("Up", "Down"));
	
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
	
	velocity = direction * SPEED
	
	move_and_slide()

func _process(delta):
	
	var MousePos = get_global_mouse_position()
	
	var attackAngle = attack.global_position.angle_to_point(MousePos)
	
	if not attack.animation == "Attack":
		attack.rotation = attackAngle
	
	if attack.animation == "Attack" and attack.frame == 5:
		attack.animation = "Nothing"
		Attacking = false

func _input(event):
	
	if event.is_action_pressed("Attack"):
		attack.animation = "Attack"
		Attacking = true
