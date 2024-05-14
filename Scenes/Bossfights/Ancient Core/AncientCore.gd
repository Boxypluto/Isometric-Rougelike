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
	# Set the speed of the two rotating layers to whatever the speed is
	layer.Speed = Speed
	layer_2.Speed = -Speed
	
	# If the CORE is shooting lasers or rifts, slow down the CORE to LaserSpeed, otherwise, go NormalSpeed
	if Lasering or Rifting:
		Speed = LaserSpeed
	else:
		Speed = NormalSpeed
	
	# Rotate the turret to face the player
	turret.rotation = turret.global_position.angle_to_point(player.global_position) - PI/2
	
	# Set the health bar's value to the CORE's health
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

# Used to know if the laser attack is currently active
var Lasering : bool = false
# Actived by the laser_timer Node
func LaserTimer():
	# Start the laser charge noise
	laser_charge.play()
	# Enable Lasering
	Lasering = true
	# For each laser...
	for laser in Lasers:
		# Make it visible
		laser.visible = true
		# Make it very transparent
		laser.modulate.a = 0.2
	
	# Wait for 2 seconds
	await get_tree().create_timer(2).timeout
	# Stop the laser charge sound
	laser_charge.stop()
	# Start the laser shoot sound
	laser_shoot.play()
	# For each laser...
	for laser in Lasers:
		# Activate the Laser's Damaging Collision
		laser.get_child(0).get_child(0).disabled = false
		# Make the Laser fully visible
		laser.modulate.a = 1
		
	# Wait 2 seconds
	await get_tree().create_timer(2).timeout
	# Stop the laser shoot sound
	laser_shoot.stop()
	# For each laser...
	for laser in Lasers:
		# Make it invisible
		laser.visible = false
		# Disable its Damagine Collision
		laser.get_child(0).get_child(0).disabled = true
	# Set lasering to false
	Lasering = false

# Used to know if the rift attack is currently active
var Rifting : bool = false
func RiftTimer():
	# Set rifting to true
	Rifting = true
	# Play the rift open sound
	rift_open.play()
	# Increment RiftIndex
	RiftIndex += 1
	# If RiftIndex is going to become out of range...
	if RiftIndex == len(Rifts):
		# Set rift index to zero
		RiftIndex = 0
	# Get the correct rift using RiftIndex on Rifts
	var rift : Sprite2D = Rifts[RiftIndex]
	# Get the Damaging Collision of the Rift and set it to col
	var col : CollisionPolygon2D = rift.get_child(0).get_child(0)
	# Make the rift semi-transparent
	rift.modulate.a = 0.1
	# Make the rift visible
	rift.visible = true
	
	# Wait 4 seconds
	await get_tree().create_timer(4).timeout
	# Make the rift fully visible
	rift.modulate.a = 1
	# Activate the Damaging Collison of the rift
	col.disabled = false
	
	# Wait 3 seconds
	await get_tree().create_timer(3).timeout
	# Set the rift to invisible
	rift.visible = false
	# Disable the Damaging Collision of the rift
	col.disabled = true
	# Set rifting to false
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
