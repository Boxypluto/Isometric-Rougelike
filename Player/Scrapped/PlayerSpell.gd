extends CharacterBody2D

const ALIVE_FRAMES : float = 16
const SPEED : float = 3
var StartVelocity
var LivingTime

@onready var spell_sprite = $SpellSprite

func _ready():
	LivingTime = ALIVE_FRAMES

func _physics_process(_delta):
	velocity = (Vector2.from_angle(rotation) * SPEED) + StartVelocity
	LivingTime -= 1
	if LivingTime < (ALIVE_FRAMES / 3):
		modulate.a = (LivingTime)/(ALIVE_FRAMES/3)
	if LivingTime <= 0:
		queue_free() 
	move_and_collide(velocity)
