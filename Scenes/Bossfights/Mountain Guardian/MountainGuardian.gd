extends CharacterBody2D

@onready var state_machine : StateMachine = $StateMachine
@onready var guardian_laser : GuardianLaserState = $StateMachine/GuardianLaserState
@onready var throw_projectile : ThrowTowerProjectileState = $StateMachine/ThrowTowerProjectileState
@onready var spawn_birds = $StateMachine/SpawnBirdsState

@onready var player = $"../Player"

@onready var laser = $Squasher/Laser
@onready var laser_collision = $Squasher/Laser/DamagingAreaComponent/CollisionPolygon2D

@onready var ring = $Squasher/Ring

@onready var bong : AudioStreamPlayer2D = $Bong

@onready var enemies_node : Node2D = $"../Enemies"

const StateArray : Array[String] = [
	"birds",
	"tower",
	"laser",
	"tower",
	"laser",
	"laser",
	"tower",
	"tower",
	"laser",
]

func _ready():
	
	# Setup Guardian Laser State
	guardian_laser.Laser = laser
	guardian_laser.Target = player
	guardian_laser.Collision = laser_collision
	guardian_laser.Parent = ring
	
	# Setup Throw Projectile State
	throw_projectile.player = player
	throw_projectile.bong = bong
	throw_projectile.enemies = enemies_node
	throw_projectile.Thrower = self
	
	# Setup Spawn Birds State
	spawn_birds.SpawnSpotArray = get_tree().get_nodes_in_group("BirdSpawner")
	spawn_birds.EnemiesNode = enemies_node
	spawn_birds.ENEMY = preload("res://Objects/Enemies/Bird/Bird.tscn")
	
	# Setup State Machine
	state_machine.initial_state = spawn_birds
	state_machine.setup()
	
	await COMP
	state_machine.change_state(throw_projectile.name)
	await COMP
	state_machine.change_state(guardian_laser.name)
	Speed = 0
	Smoothing = 0
	await COMP
	Speed = 160
	Smoothing = 0.03

var Speed : float = 160
var Distance : float = 128.0
var Smoothing : float = 0.03

@onready var Angle : float = player.global_position.angle_to_point(global_position)

func _process(delta):
	
	Angle += (Speed/Distance) * delta
	print(Angle)
	var Point : Vector2 = player.global_position + ((Vector2(cos(Angle), sin(Angle)) * Distance) / Vector2(1, 2))
	global_position = global_position.lerp(Point, Smoothing)

func MountainGuardianHit(damage):
	pass # Replace with function body.
signal COMP

func StateComplete():
	COMP.emit()
	# DO A LINEAR STATE ARYY ATHING
