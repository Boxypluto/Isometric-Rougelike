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
@onready var guardian_lase_shoot : AudioStreamPlayer2D = $"Guardian Laser"
@onready var guardian_laser_charge : AudioStreamPlayer2D = $"Guardian Laser Charge"
@onready var ambiance = $Ambiance

@onready var enemies_node : Node2D = $"../Enemies"

@onready var health_bar : ProgressBar = $"../HealthBar"

const FLASH_MAT : ShaderMaterial = preload("res://Objects/Enemies/EnemyFlashMAT.tres")

@onready var hurt_box : HurtBoxComponent = $HurtBoxComponent

@onready var health_component = $HealthComponent

@onready var health : HealthComponent = $HealthComponent

const StateArray : Array[String] = [
	"tower",
	"laser",
	"tower",
	"laser",
	"tower",
	"tower",
	"laser",
	"birds"
]

func _ready():
	
	# Setup Health Bar
	health_bar.max_value = health.Health
	
	# Setup Flash Material
	hurt_box.Hit.connect(Callable(self, "OnHit"))
	material = FLASH_MAT.duplicate()
	
	# Setup Guardian Laser State
	guardian_laser.Laser = laser
	guardian_laser.Target = player
	guardian_laser.Collision = laser_collision
	guardian_laser.Parent = ring
	guardian_laser.shoot_sound = guardian_lase_shoot
	guardian_laser.charge_sound = guardian_laser_charge
	
	# Setup Throw Projectile State
	throw_projectile.player = player
	throw_projectile.bong = bong
	throw_projectile.enemies = enemies_node
	throw_projectile.Thrower = self
	
	# Setup Spawn Birds State
	spawn_birds.SpawnSpotArray = get_tree().get_nodes_in_group("BirdSpawner")
	spawn_birds.EnemiesNode = enemies_node
	spawn_birds.ENEMY = preload("res://Objects/Enemies/Bird/Bird.tscn")
	
	await get_tree().create_timer(2).timeout
	
	# Setup State Machine
	state_machine.initial_state = spawn_birds
	state_machine.setup()

var Speed : float = 160
var Distance : float = 128.0
var Smoothing : float = 0.03

@onready var Angle : float = player.global_position.angle_to_point(global_position)

@onready var room : Room = $"../.."

func _process(delta):
	
	Angle += (Speed/Distance) * delta
	var Point : Vector2 = player.global_position + ((Vector2(cos(Angle), sin(Angle)) * Distance) / Vector2(1, 2))
	global_position = global_position.lerp(Point, Smoothing)
	
	health_bar.value = clamp(health.Health, 0, 64000000)

var StateIndex : int = 0

func StateComplete():
	
	print("NEXT STATE")
	Angle = player.global_position.angle_to_point(global_position)
	Speed = 160
	Smoothing = 0.03
	
	if StateArray[StateIndex] == "birds":
		print("BIRDS")
		state_machine.change_state(spawn_birds.name)
	elif StateArray[StateIndex] == "laser":
		print("LASER")
		state_machine.change_state(guardian_laser.name)
		Speed = 0
		Smoothing = 0
	elif StateArray[StateIndex] == "tower":
		print("THROW")
		state_machine.change_state(throw_projectile.name)
	
	if StateIndex < len(StateArray)-1:
		StateIndex += 1
	else:
		StateIndex = 0

func OnHealthZero():
	room.ProgressRooms()

func OnHit(damage):
	health.DealDamage(damage)
	material.set_shader_parameter("White", true)
	await get_tree().create_timer(0.1).timeout
	material.set_shader_parameter("White", false)
