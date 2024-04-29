extends Enemy

const TOWER_PROJECTILE : PackedScene = preload("res://Objects/Enemies/Tower/TowerProjectile.tscn")
const TOWER_TARGET : PackedScene = preload("res://Objects/Enemies/Tower/TowerTarget.tscn")

# Player
@onready var player : CharacterBody2D = $"../../Player"

@onready var enemies = $".."

func ShootProjectile():
	var projectile : TowerProjectile = TOWER_PROJECTILE.instantiate()
	var target : Node2D = TOWER_TARGET.instantiate()
	projectile.visible = false
	projectile.Target = player.position + Vector2(0, -16)
	enemies.add_child(projectile)
	enemies.add_child(target)
	target.position = player.position + Vector2(0, -32)
	target.visible = true
	projectile.position = position
	projectile.TotalDist = projectile.position.distance_to(projectile.Target)
	projectile.TargetNode = target
