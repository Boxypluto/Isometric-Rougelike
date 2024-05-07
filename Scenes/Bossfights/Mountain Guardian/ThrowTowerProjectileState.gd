extends State
class_name ThrowTowerProjectileState

const PROJECTILE : PackedScene = preload("res://Objects/Enemies/Tower/TowerProjectile.tscn")
const TARGET : PackedScene = preload("res://Objects/Enemies/Tower/TowerTarget.tscn")

var player : CharacterBody2D
var bong : AudioStreamPlayer2D
var enemies : Node2D
var Thrower : Node2D

func ShootProjectile():
	# Instantiate the PROJECTILE and TARGET
	var projectile : TowerProjectile = PROJECTILE.instantiate()
	var target : Node2D = TARGET.instantiate()
	
	# If the player is far, aim at them, if they are close, aim at itself
	var aimingFor : Vector2 
	if Thrower.position.distance_to(player.position) > 48:
		aimingFor = player.position
	else: aimingFor = Thrower.position
	
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
	
	bong.play()
