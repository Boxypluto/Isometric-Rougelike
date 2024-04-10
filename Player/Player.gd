extends CharacterBody2D

# Speed of the player
const SPEED = 64

func _physics_process(delta):

	# Set a Vector2 names "direction" to the axis of the player's input
	var direction : Vector2 = Vector2(Input.get_axis("Left", "Right"), Input.get_axis("Up", "Down"));
	
	# If two directions are pressed at once, reduce the speed to be consistent with diagonal and 
	if abs(direction.x) > 0 and abs(direction.y) > 0:
		direction *= 0.7
		direction.y /= 2
	
	velocity = direction * SPEED
	
	move_and_slide()
