extends State
class_name ThrowTowerProjectileState

const PROJECTILE : PackedScene = preload("res://Objects/Enemies/Tower/TowerProjectile.tscn")
const TARGET : PackedScene = preload("res://Objects/Enemies/Tower/TowerTarget.tscn")

var player : CharacterBody2D
var bong : AudioStreamPlayer2D
var enemies : Node2D
var Thrower : Node2D
var FireTimes : int = 16
var FireWait : float = 0.3

signal Complete

func enter():
	for time in range(FireTimes):
		# Instantiate the PROJECTILE and TARGET
		var projectile : TowerProjectile = PROJECTILE.instantiate()
		var target : Node2D = TARGET.instantiate()
		
		# Aim at the player
		var aimingFor : Vector2 
		aimingFor = player.position
		
		# Make projectile invisible
		projectile.visible = false
		
		# Set the target pos of the projectile
		projectile.Target = aimingFor
		
		# Add them to the scene
		enemies.add_child(projectile)
		enemies.add_child(target)
		
		# Set the TARGET's position
		target.position = aimingFor + Vector2(0, -16)
		# Make the TARGET visible
		target.visible = true
		
		# Set the PROJECTILE's position
		projectile.position = Thrower.position
		# Set the TotalDist varible to the distance from the player
		projectile.TotalDist = projectile.position.distance_to(projectile.Target)
		# Set the Target Node to the TARGET
		projectile.TargetNode = target
		# Set the speed so it scales with distance
		projectile.Speed = projectile.position.distance_to(projectile.Target) / 45.0
		
		bong.play()
		
		await get_tree().create_timer(FireWait).timeout
	
	Complete.emit()
