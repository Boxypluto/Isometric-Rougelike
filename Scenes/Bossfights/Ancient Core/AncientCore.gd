extends Node2D

# Audio
@onready var laser_charge : AudioStreamPlayer2D = $LaserCharge
@onready var laser_shoot : AudioStreamPlayer2D = $LaserShoot
@onready var rift_open : AudioStreamPlayer2D = $RiftOpen
@onready var turret_shoot : AudioStreamPlayer2D = $TurretShoot
@onready var turret_charge : AudioStreamPlayer2D = $TurretCharge

# Components
@onready var hurt_box = $Squasher/HurtBoxComponent
@onready var health = $Squasher/HealthComponent

# Timers
@onready var laser_timer = $LaserTimer
@onready var rift_timer = $RiftTimer
@onready var turret_timer = $TurretTimer

# Scenes
const ANCIENT_PROJECTILE = preload("res://Scenes/Bossfights/Ancient Core/AncientProjectile.tscn")

# Health Bar
@onready var health_bar = $HealthBar

# Room
@onready var room = $"../.."

# Player
@onready var player = $"../Player"

# Objects and Object Variables
var Lasers : Array
var Rifts : Array
var RiftIndex : int = 0
@onready var turret : Sprite2D = $Squasher/Turret

# Layers
@onready var layer = $Squasher/LAYER
@onready var layer_2 = $Squasher/LAYER2

# Materials
const FLASH_MAT : ShaderMaterial = preload("res://Objects/Enemies/EnemyFlashMAT.tres")

# Spin Speed
var Speed : float = 1.5
var NormalSpeed : float = 1.5
var LaserSpeed : float = 0.5

func _process(delta):
	layer.Speed = Speed
	layer_2.Speed = -Speed
	
	if Lasering or Rifting:
		Speed = LaserSpeed
	else:
		Speed = NormalSpeed
	
	turret.rotation = turret.global_position.angle_to_point(player.global_position) - PI/2
	
	health_bar.value = clamp(health.Health, 0, 64000000)

func _ready():
	
	# Setup Flash Material
	hurt_box.Hit.connect(Callable(self, "OnHit"))
	material = FLASH_MAT.duplicate()
	health_bar.max_value = health.Health
	
	# Get Object Arrays
	Lasers = get_tree().get_nodes_in_group("AncientLaser")
	Rifts = get_tree().get_nodes_in_group("AncientRift")
	
	# Set Lasers to invisible and disabled
	for laser in Lasers:
		laser.visible = false
		laser.get_child(0).get_child(0).disabled = true
	
	# Showcase each attack
	await get_tree().create_timer(4).timeout
	TurretTimer()
	await get_tree().create_timer(6).timeout
	LaserTimer()
	await get_tree().create_timer(9).timeout
	RiftTimer()
	await get_tree().create_timer(4).timeout
	
	# Then start doing all of them
	turret_timer.start()
	laser_timer.start()
	rift_timer.start()

var Lasering : bool = false
func LaserTimer():
	laser_charge.play()
	Lasering = true
	for laser in Lasers:
		laser.visible = true
		laser.modulate.a = 0.2
	await get_tree().create_timer(2).timeout
	laser_charge.stop()
	laser_shoot.play()
	for laser in Lasers:
		laser.get_child(0).get_child(0).disabled = false
		laser.modulate.a = 1
	await get_tree().create_timer(2).timeout
	laser_shoot.stop()
	for laser in Lasers:
		laser.visible = false
		laser.get_child(0).get_child(0).disabled = true
	Lasering = false

var Rifting : bool = false
func RiftTimer():
	Rifting = true
	rift_open.play()
	print("RIFT")
	RiftIndex += 1
	if RiftIndex == len(Rifts):
		RiftIndex = 0
	var rift : Sprite2D = Rifts[RiftIndex]
	var col : CollisionPolygon2D = rift.get_child(0).get_child(0)
	rift.modulate.a = 0.1
	rift.visible = true
	await get_tree().create_timer(4).timeout
	rift.modulate.a = 1
	col.disabled = false
	await get_tree().create_timer(3).timeout
	rift.visible = false
	col.disabled = true

	Rifting = false

func TurretTimer():
	turret_charge.play()
	await get_tree().create_timer(0.5).timeout
	for proj in range(5):
		turret_shoot.play()
		var projectile = ANCIENT_PROJECTILE.instantiate()
		projectile.Direction = turret.global_position.direction_to(player.global_position)
		turret.get_parent().add_child(projectile)
		projectile.position = turret.position
		projectile.z_index = turret.z_index
		await get_tree().create_timer(0.5).timeout

func OnHit(damage):
	health.DealDamage(damage)
	material.set_shader_parameter("White", true)
	await get_tree().create_timer(0.1).timeout
	material.set_shader_parameter("White", false)

func OnHealthZero():
	room.ProgressRooms()
